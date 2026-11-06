from fastapi import FastAPI
from app.api.health import router as health_router

app = FastAPI(
    title="HR Policy Automation API",
    version="0.1.0",
    description="Synthetic HR ticket, policy, routing, and SLA workflow."
)
app.include_router(health_router, prefix="/api")

@app.get("/")
def root():
    return {"name": "HR Policy Automation System", "status": "running"}
