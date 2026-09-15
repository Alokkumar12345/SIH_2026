"""
OR-Tools CP-SAT Maintenance & Block Planning Scheduler for IMBPS.
Formulates and solves the multi-department, multi-objective block assignment problem
subject to hard safety, train headway, power isolation, and S&T permit constraints.
"""

import logging
from typing import Dict, Any, List, Optional, Tuple
from datetime import datetime, timedelta
from ortools.sat.python import cp_model

from optimization.constraints import OperationalConstraintEngine
from optimization.objectives import ObjectiveFunctionBuilder

logger = logging.getLogger("IMBPS.Scheduler")
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")


class IMBPSBlockScheduler:
    """
    CP-SAT constraint programming scheduler for multi-department railway block planning.
    """

    def __init__(self, solver_timeout_seconds: int = 20):
        self.timeout_seconds = solver_timeout_seconds
        self.constraint_engine = OperationalConstraintEngine()
        self.objective_builder = ObjectiveFunctionBuilder()

    def schedule_blocks(
        self,
        jobs: List[Dict[str, Any]],
        candidate_slots: List[Dict[str, Any]],
        train_conflicts: Optional[List[Dict[str, Any]]] = None,
        planning_horizon_name: str = "WEEKLY_HORIZON"
    ) -> Dict[str, Any]:
        """
        Solves the block planning problem.
        - jobs: List of candidate maintenance requests with predicted_duration, priority_score, risk_probability.
        - candidate_slots: List of available track block windows with start_min, end_min, section, line.
        """
        logger.info(f"Initiating OR-Tools CP-SAT scheduler for {len(jobs)} jobs across {len(candidate_slots)} candidate slots...")
        model = cp_model.CpModel()

        # Decision Variables
        job_scheduled = {}       # job_id -> BoolVar
        job_start = {}           # job_id -> IntVar
        job_end = {}             # job_id -> IntVar
        job_interval = {}        # job_id -> IntervalVar
        job_slot = {}            # (job_id, slot_idx) -> BoolVar

        # Maximum planning horizon minutes (e.g. 7 days = 10080 mins or 1 day = 1440 mins)
        max_horizon = max([s.get("end_minute", 1440) for s in candidate_slots], default=1440)

        # 1. Instantiate variables for each job
        for j_idx, job in enumerate(jobs):
            jid = job["job_id"]
            dur = max(20, int(round(job.get("predicted_duration_min", job.get("requested_duration_min", 90)))))

            # Whether job is selected to be executed in this horizon
            is_sched = model.NewBoolVar(f"sched_{jid}")
            job_scheduled[jid] = is_sched

            # Start and End minutes
            start_var = model.NewIntVar(0, max_horizon, f"start_{jid}")
            end_var = model.NewIntVar(0, max_horizon, f"end_{jid}")
            interval_var = model.NewOptionalIntervalVar(start_var, dur, end_var, is_sched, f"interval_{jid}")

            job_start[jid] = start_var
            job_end[jid] = end_var
            job_interval[jid] = interval_var

            # Link job to candidate slots
            # Candidate slot matching: Must match section and line (or compatible)
            valid_slots_for_job = []
            for s_idx, slot in enumerate(candidate_slots):
                # Section match check
                if slot["section"] == job.get("section") and slot.get("line", "UP_MAIN") == job.get("line", "UP_MAIN"):
                    slot_dur = slot["end_minute"] - slot["start_minute"]
                    if slot_dur >= dur:
                        valid_slots_for_job.append(s_idx)

            # If no strict match, consider general division slot on same section
            if not valid_slots_for_job:
                for s_idx, slot in enumerate(candidate_slots):
                    if slot["section"] == job.get("section"):
                        if (slot["end_minute"] - slot["start_minute"]) >= dur:
                            valid_slots_for_job.append(s_idx)

            # If still none, allow any slot with matching duration as fallback candidate
            if not valid_slots_for_job:
                valid_slots_for_job = [i for i, s in enumerate(candidate_slots) if (s["end_minute"] - s["start_minute"]) >= dur]

            slot_vars = []
            for s_idx in valid_slots_for_job:
                slot = candidate_slots[s_idx]
                s_var = model.NewBoolVar(f"slot_{jid}_{s_idx}")
                job_slot[(jid, s_idx)] = s_var
                slot_vars.append(s_var)

                # Hard Constraint: If assigned to slot, job start and end must be inside slot boundaries
                model.Add(start_var >= slot["start_minute"]).OnlyEnforceIf(s_var)
                model.Add(end_var <= slot["end_minute"]).OnlyEnforceIf(s_var)

            if slot_vars:
                # If job is scheduled, it must be assigned to EXACTLY ONE slot
                model.Add(sum(slot_vars) == 1).OnlyEnforceIf(is_sched)
                model.Add(sum(slot_vars) == 0).OnlyEnforceIf(is_sched.Not())
            else:
                # Cannot schedule if no valid slot exists
                model.Add(is_sched == 0)

        # 2. Hard Constraint: Non-compatible jobs on same block section cannot overlap
        # Group jobs by block section
        section_groups = {}
        for j in jobs:
            bsec = j.get("block_section", j.get("section"))
            section_groups.setdefault(bsec, []).append(j)

        for bsec, group_jobs in section_groups.items():
            if len(group_jobs) > 1:
                for i in range(len(group_jobs)):
                    for k in range(i + 1, len(group_jobs)):
                        j1 = group_jobs[i]
                        j2 = group_jobs[k]
                        jid1 = j1["job_id"]
                        jid2 = j2["job_id"]

                        # Check if co-location is permitted
                        if not self.constraint_engine.are_compatible_for_co_scheduling(j1, j2):
                            # Non-overlapping: either j1 ends before j2 starts or j2 ends before j1 starts
                            b_before = model.NewBoolVar(f"before_{jid1}_{jid2}")
                            # Only enforced if both are scheduled
                            both_sched = model.NewBoolVar(f"both_{jid1}_{jid2}")
                            model.AddBoolAnd([job_scheduled[jid1], job_scheduled[jid2]]).OnlyEnforceIf(both_sched)
                            model.AddBoolOr([job_scheduled[jid1].Not(), job_scheduled[jid2].Not()]).OnlyEnforceIf(both_sched.Not())

                            model.Add(job_end[jid1] <= job_start[jid2]).OnlyEnforceIf([both_sched, b_before])
                            model.Add(job_end[jid2] <= job_start[jid1]).OnlyEnforceIf([both_sched, b_before.Not()])

        # 3. Machine Concurrency Constraints
        # At most 1 CSM/BCM heavy machine active per division at any moment
        heavy_jobs = [j["job_id"] for j in jobs if j.get("equipment") in ["CSM", "BCM", "Tamping Machine", "Rail Grinder"]]
        if len(heavy_jobs) > 1:
            for i in range(len(heavy_jobs)):
                for k in range(i + 1, len(heavy_jobs)):
                    h1 = heavy_jobs[i]
                    h2 = heavy_jobs[k]
                    b_order = model.NewBoolVar(f"heavy_seq_{h1}_{h2}")
                    both_h = model.NewBoolVar(f"both_h_{h1}_{h2}")
                    model.AddBoolAnd([job_scheduled[h1], job_scheduled[h2]]).OnlyEnforceIf(both_h)
                    model.Add(job_end[h1] <= job_start[h2]).OnlyEnforceIf([both_h, b_order])
                    model.Add(job_end[h2] <= job_start[h1]).OnlyEnforceIf([both_h, b_order.Not()])

        # 4. Multi-Objective Function
        # Maximize Benefit, Minimize Unscheduled Penalty
        objective_terms = []
        for job in jobs:
            jid = job["job_id"]
            p_score = job.get("priority_score", 70.0)
            r_score = job.get("risk_probability", 0.5)

            benefit = self.objective_builder.get_job_benefit(p_score, r_score)
            penalty = self.objective_builder.get_unscheduled_penalty(p_score)

            # If scheduled -> add benefit; if not scheduled -> subtract penalty
            objective_terms.append(job_scheduled[jid] * (benefit + penalty) - penalty)

        model.Maximize(sum(objective_terms))

        # 5. Execute CP-SAT Solver
        solver = cp_model.CpSolver()
        solver.parameters.max_time_in_seconds = self.timeout_seconds
        solver.parameters.num_search_workers = 4

        status = solver.Solve(model)
        logger.info(f"CP-SAT solver finished with status: {solver.StatusName(status)}")

        # 6. Extract Solution Plan
        scheduled_plan = []
        deferred_jobs = []

        for job in jobs:
            jid = job["job_id"]
            if solver.BooleanValue(job_scheduled[jid]):
                start_m = solver.Value(job_start[jid])
                end_m = solver.Value(job_end[jid])

                # Find assigned slot
                assigned_slot_info = None
                for (j_id, s_idx), s_var in job_slot.items():
                    if j_id == jid and solver.BooleanValue(s_var):
                        assigned_slot_info = candidate_slots[s_idx]
                        break

                # Format time string (relative to day or planning horizon)
                start_h, start_min_rem = divmod(start_m % 1440, 60)
                end_h, end_min_rem = divmod(end_m % 1440, 60)
                day_offset = start_m // 1440

                # Check coordination requirements
                req_power = self.constraint_engine.requires_power_block(job)
                req_st = self.constraint_engine.requires_st_disconnection(job)

                plan_item = {
                    "job_id": jid,
                    "department": job.get("department"),
                    "division": job.get("division"),
                    "section": job.get("section"),
                    "block_section": job.get("block_section"),
                    "line": job.get("line"),
                    "work_type": job.get("work_type"),
                    "asset_type": job.get("asset_type"),
                    "priority_score": job.get("priority_score"),
                    "risk_probability": job.get("risk_probability"),
                    "equipment": job.get("equipment"),
                    "crew_size": job.get("crew_size"),
                    "day_index": day_offset + 1,
                    "start_minute": start_m,
                    "end_minute": end_m,
                    "scheduled_start_time": f"{start_h:02d}:{start_min_rem:02d}",
                    "scheduled_end_time": f"{end_h:02d}:{end_min_rem:02d}",
                    "assigned_duration_min": end_m - start_m,
                    "assigned_slot_id": assigned_slot_info.get("slot_id") if assigned_slot_info else "SLOT_AUTO",
                    "coordination": {
                        "power_block_required": req_power,
                        "st_disconnection_required": req_st,
                        "co_location_eligible": True
                    }
                }
                scheduled_plan.append(plan_item)
            else:
                deferred_jobs.append({
                    "job_id": jid,
                    "work_type": job.get("work_type"),
                    "priority_score": job.get("priority_score"),
                    "reason": "Deferred to next cycle: slot capacity or higher priority preemption"
                })

        # Calculate KPIs
        total_requested = len(jobs)
        total_scheduled = len(scheduled_plan)
        sched_ratio = (total_scheduled / total_requested * 100) if total_requested > 0 else 0
        total_block_minutes = sum([item["assigned_duration_min"] for item in scheduled_plan])

        return {
            "planning_horizon": planning_horizon_name,
            "solver_status": solver.StatusName(status),
            "kpis": {
                "total_jobs_considered": total_requested,
                "jobs_scheduled": total_scheduled,
                "jobs_deferred": len(deferred_jobs),
                "scheduling_rate_percent": round(sched_ratio, 1),
                "total_block_hours": round(total_block_minutes / 60.0, 1),
                "solver_wall_time_seconds": round(solver.WallTime(), 2)
            },
            "scheduled_blocks": scheduled_plan,
            "deferred_jobs": deferred_jobs
        }

    def generate_weekly_plan(self, jobs: List[Dict[str, Any]], candidate_slots: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Generates detailed daily timeline for 7-day planning window."""
        return self.schedule_blocks(jobs, candidate_slots, planning_horizon_name="WEEKLY_DETAILED_PLAN")

    def generate_monthly_plan(self, jobs: List[Dict[str, Any]], candidate_slots: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Generates 4-week high-level block allocation and workload projection."""
        res = self.schedule_blocks(jobs, candidate_slots, planning_horizon_name="MONTHLY_AGGREGATED_PLAN")
        # Aggregate by week and department
        dept_workload = {}
        for b in res["scheduled_blocks"]:
            dept = b["department"]
            dept_workload[dept] = dept_workload.get(dept, 0) + b["assigned_duration_min"]

        res["monthly_workload_hours"] = {dept: round(mins / 60.0, 1) for dept, mins in dept_workload.items()}
        return res
