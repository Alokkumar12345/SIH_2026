"""
Runner script for IMBPS FastAPI Backend Server.
Runs on http://localhost:8000
"""

import uvicorn
import os
import sys
from pathlib import Path

# Add backend directory to sys.path
BASE_DIR = Path(__file__).resolve().parent
if str(BASE_DIR) not in sys.path:
    sys.path.insert(0, str(BASE_DIR))

if __name__ == "__main__":
    port = int(os.getenv("PORT", 8000))
    print(f"[*] Starting IMBPS FastAPI Backend on http://localhost:{port}...")
    uvicorn.run("app.main:app", host="0.0.0.0", port=port, reload=True)
