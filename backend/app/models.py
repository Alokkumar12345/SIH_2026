"""
Pydantic data models and schemas for IMBPS API.
"""

from typing import Dict, Any, List, Optional
from pydantic import BaseModel, Field

class LoginRequest(BaseModel):
    username: str = Field(..., example="railway_central")
    password: str = Field(..., example="RailBoard@2026")
    captcha: Optional[str] = None

class LoginResponse(BaseModel):
    token: str
    user: Dict[str, Any]

class EditBlockRequest(BaseModel):
    block_id: str
    scheduled_date: Optional[str] = None
    preferred_start: Optional[str] = None
    preferred_end: Optional[str] = None
    duration_min: Optional[int] = None
    line: Optional[str] = None
    equipment: Optional[str] = None
    crew_size: Optional[int] = None
    priority: Optional[str] = None
    notes: Optional[str] = None

class AuthorizeBlockRequest(BaseModel):
    block_id: str
    notes: Optional[str] = None

class BatchAuthorizeRequest(BaseModel):
    block_ids: Optional[List[str]] = None

class LogMaintenanceHistoryRequest(BaseModel):
    block_id: Optional[str] = None
    department: str = Field(..., example="TMS") # TMS, SMMS, TDMS
    division: str = Field("Asansol (ASN)", example="Asansol (ASN)")
    section: str = Field("UDL-SNT", example="UDL-SNT")
    block_section: str = Field("UDL-UKA", example="UDL-UKA")
    line: str = Field("UP_MAIN", example="UP_MAIN")
    work_type: str = Field(..., example="Tamping Machine Deployment")
    asset_type: str = Field("Track", example="Track")
    crew_size: int = Field(8, example=8)
    equipment: str = Field("CSM-952", example="CSM-952")
    requested_duration_min: int = Field(150, example=150)
    actual_duration_min: int = Field(150, example=150)
    actual_start: str = Field(..., example="2026-09-08T11:30:00")
    actual_end: str = Field(..., example="2026-09-08T14:00:00")
    completion_status: str = Field("Completed", example="Completed")
    train_detention_minutes: int = Field(0, example=0)
    work_remarks: Optional[str] = "Maintenance executed in planned block window without adverse incidents."
    logged_by: Optional[str] = "Section Engineer"

class RetrainModelRequest(BaseModel):
    trigger_reason: str = Field("MANUAL_ADMIN_TRIGGER", example="MANUAL_ADMIN_TRIGGER")
