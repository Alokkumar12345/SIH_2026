"""
Optimization Objectives for IMBPS Block Scheduler.
Defines multi-objective utility weights and penalty terms for OR-Tools CP-SAT.
"""

from typing import Dict, Any

DEFAULT_OBJECTIVE_WEIGHTS = {
    # Positive Utility Weights (to MAXIMIZE)
    "priority_benefit": 100,      # Multiplier for maintenance priority score (0-100)
    "risk_reduction": 80,         # Multiplier for asset risk probability (0-100)
    "co_location_bonus": 50,      # Bonus reward for multi-department co-scheduling
    "block_utilization": 20,      # Reward for filling available block slot minutes

    # Negative Penalty Weights (to MINIMIZE)
    "unscheduled_penalty": 120,   # Penalty for leaving high-priority jobs unscheduled
    "train_conflict_penalty": 150,# Heavy penalty for encroaching train paths
    "unused_block_penalty": 15,   # Penalty per minute of granted block left unused
    "window_deviation_penalty": 10# Penalty for deviating from requested maintenance window
}


class ObjectiveFunctionBuilder:
    """Configures the scalarized multi-objective function for the CP-SAT solver."""

    def __init__(self, custom_weights: Dict[str, int] = None):
        self.weights = DEFAULT_OBJECTIVE_WEIGHTS.copy()
        if custom_weights:
            self.weights.update(custom_weights)

    def get_job_benefit(self, priority_score: float, risk_score: float) -> int:
        """Calculates integer reward score for scheduling a job."""
        # CP-SAT requires integer coefficients
        return int(
            (self.weights["priority_benefit"] * priority_score) +
            (self.weights["risk_reduction"] * (risk_score * 100.0))
        )

    def get_unscheduled_penalty(self, priority_score: float) -> int:
        """Calculates integer penalty for leaving a job unscheduled."""
        return int(self.weights["unscheduled_penalty"] * priority_score)
