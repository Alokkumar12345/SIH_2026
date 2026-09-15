"""
Authentication routes for IMBPS.
Handles login, role retrieval, and session verification.
"""

from fastapi import APIRouter, HTTPException, status
from app.auth import authenticate_user, USERS_DB
from app.models import LoginRequest, LoginResponse

router = APIRouter(prefix="/api/auth", tags=["Authentication"])

@router.post("/login", response_model=LoginResponse)
def login(request: LoginRequest):
    profile = authenticate_user(request.username, request.password)
    if not profile:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid Indian Railways User ID or Password."
        )
    # Generate mock session token
    token = f"IMBPS-IR-TOKEN-{profile.role.upper()}-{profile.username}"
    return LoginResponse(
        token=token,
        user=profile.model_dump()
    )

@router.get("/accounts")
def get_demo_accounts():
    """Returns list of all available railway accounts for easy login selection."""
    accounts = []
    for uname, data in USERS_DB.items():
        accounts.append({
            "username": uname,
            "password": data["password"],
            "name": data["profile"]["name"],
            "role": data["profile"]["role"],
            "role_display": data["profile"]["role_display"],
            "department": data["profile"].get("department"),
            "division": data["profile"].get("division")
        })
    return accounts
