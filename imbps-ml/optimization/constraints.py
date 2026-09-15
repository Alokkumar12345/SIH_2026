"""
COA Operational Constraints Layer for IMBPS Optimization.
Defines Hard vs Soft constraints, railway safety protocols, and multi-department
coordination dependencies between TMS, SMMS, and TDMS.
"""

import logging
from typing import Dict, Any, List, Set, Tuple
from datetime import datetime, time

logger = logging.getLogger("IMBPS.Constraints")

# Train Priority Classes in Indian Railways (Lower integer = Higher priority)
TRAIN_PRIORITY_CLASSES = {
    "PRESTIGE_EXPRESS": 1,     # Vande Bharat, Rajdhani, Shatabdi
    "MAIL_EXPRESS": 2,        # Superfast, Mail, Express
    "SUBURBAN_PASSENGER": 3,   # Suburban EMU/MEMU, Passenger
    "FREIGHT_GOODS": 4         # Freight rakes, Parcel trains
}

# Multi-Department Co-location Compatibility Rules
# Returns True if activities can safely share the same block section and window
CO_LOCATION_PERMITTED = {
    # Engineering Track Tamping can safely co-occur with OHE Inspection and S&T Bond Testing
    ("Tamping", "OHE Foot Patrol & Current Collection Test"): True,
    ("Tamping", "Dropper Renewal"): True,
    ("Tamping", "Track Relay Calibration & Drop Shunt Testing"): True,
    # Track Renewal and OHE Wire replacement are heavy activities requiring dedicated line possession
    ("Track Renewal", "OHE Wire Replacement"): False,
    # S&T Point machine work and TRD Isolator inspection
    ("Point Motor Replacement", "Pole-Mounted Isolator Contact Cleaning & Alignment"): True
}


class OperationalConstraintEngine:
    """Evaluates and enforces railway operational rules and dependencies."""

    @staticmethod
    def requires_power_block(job: Dict[str, Any]) -> bool:
        """Determines if a maintenance job requires 25 kV AC OHE traction power isolation."""
        dept = job.get("department", "")
        work_type = job.get("work_type", "")
        asset_type = job.get("asset_type", "")

        if dept == "TRD":
            # Almost all OHE line works require power isolation
            if asset_type in ["OHE", "Insulator", "Section Insulator", "Neutral Section", "Cantilever"]:
                return True
        elif dept == "ENGINEERING":
            # Heavy on-track machinery with high masts (e.g. BCM, Crane) require power cutoff
            if work_type in ["Track Renewal", "Ballast Cleaning"]:
                return True
        return False

    @staticmethod
    def requires_st_disconnection(job: Dict[str, Any]) -> bool:
        """Determines if job requires S&T gear disconnection notice (e.g. Signal/Point freeze)."""
        dept = job.get("department", "")
        work_type = job.get("work_type", "")

        if dept == "SIGNAL_TELECOM":
            return True
        elif dept == "ENGINEERING":
            # Track tamping or renewal affects track circuits and point detectors
            if work_type in ["Tamping", "Track Renewal", "Rail Grinding"]:
                return True
        return False

    @staticmethod
    def are_compatible_for_co_scheduling(job1: Dict[str, Any], job2: Dict[str, Any]) -> bool:
        """
        Checks if two multi-department jobs on the same block section can be
        piggybacked into a single shared block window to maximize line utilization.
        """
        if job1.get("block_section") != job2.get("block_section"):
            return False
        if job1.get("line") != job2.get("line"):
            return False

        # Two heavy machines cannot occupy the same section
        is_heavy1 = job1.get("equipment") in ["CSM", "BCM", "Tamping Machine", "Rail Grinder"]
        is_heavy2 = job2.get("equipment") in ["CSM", "BCM", "Tamping Machine", "Rail Grinder"]
        if is_heavy1 and is_heavy2:
            return False

        wt1 = job1.get("work_type", "")
        wt2 = job2.get("work_type", "")
        if (wt1, wt2) in CO_LOCATION_PERMITTED or (wt2, wt1) in CO_LOCATION_PERMITTED:
            return True

        # S&T inspection and TRD inspection can generally co-occur
        if job1.get("department") != job2.get("department"):
            return True

        return False

    @staticmethod
    def parse_time_to_minutes(time_str: str) -> int:
        """Converts 'HH:MM' string to minute of day (0 - 1439)."""
        parts = time_str.split(":")
        return int(parts[0]) * 60 + int(parts[1])
