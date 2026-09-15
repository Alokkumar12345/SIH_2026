# SIH_2026/backend/app/routes/auth_routes.py
from fastapi import APIRouter, HTTPException, status, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel
from typing import Optional

from app.auth import (
    authenticate_user, 
    create_access_token, 
    decode_access_token, 
    create_user_by_admin
)
from app.models import LoginRequest, LoginResponse

router = APIRouter(prefix="/api/auth", tags=["Authentication"])
security = HTTPBearer()

class CreateEmployeeRequest(BaseModel):
    username: str
    password: str
    name: str
    role: str                       # 'section_engineer', etc.
    role_display: str
    zone: Optional[str] = None
    zone_code: Optional[str] = None
    division: Optional[str] = None
    division_code: Optional[str] = None
    department: Optional[str] = None
    department_display: Optional[str] = None
    section: Optional[str] = None
    section_display: Optional[str] = None


def get_current_user_token(credentials: HTTPAuthorizationCredentials = Depends(security)):
    token = credentials.credentials
    payload = decode_access_token(token)
    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Session has expired or token is invalid."
        )
    return payload


# 1. Standard Login Endpoint (Preserves identical JSON contract for frontend)
@router.post("/login", response_model=LoginResponse)
def login(request: LoginRequest):
    profile = authenticate_user(request.username, request.password)
    if not profile:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid Indian Railways User ID or Password."
        )
    
    # Real cryptographic JWT signed with secret and expiration
    token = create_access_token(profile)
    
    return LoginResponse(
        token=token,
        user=profile.model_dump()
    )


# 2. Engineer/Admin Provisioning Route (No public registration)
@router.post("/register-employee")
def register_employee(
    request: CreateEmployeeRequest, 
    current_user: dict = Depends(get_current_user_token)
):
    # Only section engineers and admins can provision accounts
    allowed_creators = ["central_admin", "zonal_admin", "divisional_admin", "section_engineer"]
    if current_user.get("role") not in allowed_creators:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only authorized engineers or administrators can register staff."
        )

    success = create_user_by_admin(request.model_dump(), created_by=current_user.get("sub"))
    if not success:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Failed to create employee. Username may already exist."
        )

    return {"status": "success", "message": f"Account for {request.username} successfully provisioned."}