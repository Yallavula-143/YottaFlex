# Architecture

## Pattern
Modular monolith: FastAPI application with separate domain services, SQL database, deterministic offline data generator, validation pipeline, and analytics/dashboard layer.

## Main flow
Employee request -> ticket creation -> classification -> sensitivity detection -> routing -> completeness check -> policy/knowledge retrieval -> policy-version and audience validation -> evidence-backed answer or HR escalation -> SLA tracking -> resolution -> audit events and metrics.

## Important design decisions
- Master data is generated before dependent records.
- All IDs are deterministic and immutable.
- Historical assignments and ticket events are append-only.
- Policy versions are never overwritten.
- Ground truth is kept outside operational input data.
- Business-hour calculations use a configurable calendar and timezone.
- The baseline is valid first; labelled anomalies are injected afterward.
