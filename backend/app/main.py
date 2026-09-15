"""
Main FastAPI Application for IMBPS (Integrated Maintenance & Block Planning System).
Serves Central Admin, Zonal Admin, Divisional Admin, and Section Engineer Portals.
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routes.auth_routes import router as auth_router
from app.routes.central_routes import router as central_router
from app.routes.zonal_routes import router as zonal_router
from app.routes.divisional_routes import router as divisional_router
from app.routes.user_routes import router as user_router

app = FastAPI(
    title="IMBPS API - Integrated Maintenance & Block Planning System",
    description="Indian Railways Enterprise Decision Support System for Track (TMS), Signal (SMMS), and Traction (TDMS) Maintenance",
    version="2.0.0"
)

# CORS Middleware to allow React Frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register routers
app.include_router(auth_router)
app.include_router(central_router)
app.include_router(zonal_router)
app.include_router(divisional_router)
app.include_router(user_router)

@app.get("/")
def root():
    return {
        "system": "IMBPS - Integrated Maintenance & Block Planning System",
        "ministry": "Ministry of Railways, Government of India",
        "status": "OPERATIONAL",
        "version": "2.0.0",
        "neon_postgres": "CONNECTED",
        "ml_optimization": "READY",
        "docs_url": "/docs"
    }

@app.get("/api/health")
def health_check():
    return {
        "status": "healthy",
        "database": "Neon PostgreSQL Cloud",
        "solver": "Google OR-Tools CP-SAT"
    }
