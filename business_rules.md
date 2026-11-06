# Business Rules

1. Resolve policy applicability against the ticket's relevant date, effective_from/effective_to, approved status, and employee audience.
2. Never answer a policy question as fact without an applicable evidence source.
3. Sensitive employee-relations cases route to CONFIDENTIAL_HR and are not visible in general queues.
4. Incomplete or ambiguous requests move to WAITING_FOR_EMPLOYEE and receive a clarification message.
5. Every status and assignment change creates a TicketEvent; history is not overwritten.
6. SLA deadlines are computed using a named business calendar, timezone, weekends, holidays, and configured working hours.
7. Ground-truth labels are evaluation-only and never used as model/business-rule input.
8. Injected anomalies are labelled and isolated; do not silently corrupt unrelated baseline rows.
