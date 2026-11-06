# HR Policy Automation System

A synthetic, auditable HR helpdesk workflow for policy-grounded answers, sensitive-case routing, clarification, SLA tracking, and evaluation.

## Stack
- Python 3.11+
- FastAPI, SQLAlchemy, Pydantic
- SQLite for local development (PostgreSQL-ready schema design)
- Pandas / NumPy / Faker for deterministic synthetic data
- Pytest for validation
- Streamlit for the dashboard (later phase)

## Quick start
```bash
python -m venv .venv
# Windows: .venv\Scripts\activate
# macOS/Linux: source .venv/bin/activate
pip install -r requirements.txt
python scripts/run_all.py --seed 20261022 --scale starter
```

Run the API:
```bash
uvicorn app.main:app --reload
```
Open http://127.0.0.1:8000/docs

## Project phases
1. Database schema and data dictionary
2. Deterministic synthetic data generation
3. Ticket, policy, routing, conversation, and SLA services
4. Labelled anomaly injection and separate ground truth
5. Validation, tests, metrics, reproducibility
6. API and dashboard

## Data and privacy
All records are synthetic. Do not add real employee data, credentials, or confidential information.
