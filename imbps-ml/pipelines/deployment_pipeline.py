"""
Division-Level Model Deployment & Distribution Pipeline for IMBPS.
Distributes approved model artifacts to division inference services (ASN, HWH, UMB)
and supports instant rollback to prior versions.
"""

import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
sys.path.append(str(BASE_DIR))

import json
import logging
from datetime import datetime
from typing import Dict, Any, List

from config.settings import REGISTRY_DIR, REGISTRY_FILE

logger = logging.getLogger("IMBPS.Deployment")
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

DIVISIONS = ["ASN", "HWH", "UMB"]


class ModelDeploymentPipeline:
    """Manages model artifact distribution to railway divisions with rollback capability."""

    def __init__(self):
        self.deployment_log_file = REGISTRY_DIR / "deployment_history.json"

    def distribute_approved_model(self, model_version: str = None) -> Dict[str, Any]:
        """
        Distributes the active production model to division inference nodes.
        """
        if not REGISTRY_FILE.exists():
            raise FileNotFoundError("Model Registry file not found.")

        with open(REGISTRY_FILE, "r", encoding="utf-8") as f:
            registry = json.load(f)

        # Identify production model
        target_version = model_version
        if not target_version:
            for ver, meta in registry.items():
                if meta.get("status") == "PRODUCTION" and "duration" in ver:
                    target_version = ver
                    break

        if not target_version or target_version not in registry:
            raise ValueError(f"Target model version '{target_version}' not found in registry.")

        target_meta = registry[target_version]
        artifact_path = target_meta.get("file_path")

        logger.info(f"Distributing approved model [{target_version}] to division deployments: {DIVISIONS}")

        division_deployments = {}
        for div in DIVISIONS:
            # Simulate secure deployment handshake to division node
            div_status = {
                "division": div,
                "deployed_model_version": target_version,
                "status": "ACTIVE_SERVING",
                "deployed_at": datetime.now().isoformat(),
                "artifact": artifact_path
            }
            division_deployments[div] = div_status

        deployment_record = {
            "model_version": target_version,
            "timestamp": datetime.now().isoformat(),
            "target_divisions": DIVISIONS,
            "status": "DEPLOYED_SUCCESSFULLY",
            "division_status": division_deployments
        }

        # Log deployment history
        history = []
        if self.deployment_log_file.exists():
            try:
                with open(self.deployment_log_file, "r", encoding="utf-8") as f:
                    history = json.load(f)
            except Exception:
                history = []
        history.append(deployment_record)
        with open(self.deployment_log_file, "w", encoding="utf-8") as f:
            json.dump(history, f, indent=2)

        logger.info(f"Model [{target_version}] successfully deployed to all divisions.")
        return deployment_record

    def rollback_model(self, target_version: str) -> Dict[str, Any]:
        """
        Rolls back production model to a designated prior version in the registry.
        """
        if not REGISTRY_FILE.exists():
            raise FileNotFoundError("Model Registry file not found.")

        with open(REGISTRY_FILE, "r", encoding="utf-8") as f:
            registry = json.load(f)

        if target_version not in registry:
            raise ValueError(f"Cannot rollback: version '{target_version}' does not exist in registry.")

        # Demote current production models
        for ver, meta in registry.items():
            if meta.get("status") == "PRODUCTION":
                meta["status"] = "RETIRED_VIA_ROLLBACK"

        # Promote rollback target
        registry[target_version]["status"] = "PRODUCTION"
        with open(REGISTRY_FILE, "w", encoding="utf-8") as f:
            json.dump(registry, f, indent=2)

        # Distribute rollback model
        deploy_res = self.distribute_approved_model(target_version)
        deploy_res["action"] = "ROLLBACK_EXECUTED"
        logger.info(f"Rollback to [{target_version}] completed successfully.")
        return deploy_res


# Singleton deployment pipeline
deployment_pipeline = ModelDeploymentPipeline()

if __name__ == "__main__":
    res = deployment_pipeline.distribute_approved_model()
    print(json.dumps(res, indent=2))
