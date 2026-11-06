# Data Dictionary (initial schema)

All IDs are immutable text primary keys. Timestamps use ISO-8601 with timezone. Dates use YYYY-MM-DD.

| Entity | Key fields | Required validation |
|---|---|---|
| Department | department_id, department_name | Unique ID and name |
| Employee | employee_id, department_id, employee_number, email, employment_type, hire_date, employment_status, audience_code | Department FK; unique employee number/email; enum checks |
| Category | category_id, category_code, category_name | Unique category code; controlled category enum |
| PolicyDocument | policy_id, department_id, policy_code, title, audience, owner_role, lifecycle_state | Unique policy code; optional department FK |
| PolicyVersion | version_id, policy_id, version_number, effective_from, effective_to, status, content | Policy FK; unique policy/version; end date >= start date |
| KnowledgeArticle | article_id, version_id, title, question_pattern, answer_snippet, keywords, lifecycle_state | Version FK; active article must reference approved applicable version |
| Ticket | ticket_id, employee_id, category_id, subject, description, created_at, status, priority, is_sensitive, issue_type | Employee/category FKs; controlled lifecycle and priority |
| Message | message_id, ticket_id, sender_employee_id, sender_type, message_type, body, created_at | Ticket FK; sender FK optional for SYSTEM |
| Assignment | assignment_id, ticket_id, assigned_to_employee_id, assigned_queue, assigned_at, unassigned_at, assignment_reason, is_current | Ticket FK; employee optional for queue assignment; date ordering |
| SLA | sla_id, ticket_id, calendar_code, first_response_due_at, resolution_due_at, first_response_at, resolved_at, sla_status | One SLA per ticket; due dates calculated from business calendar |
| Resolution | resolution_id, ticket_id, resolution_code, resolution_summary, resolved_by, resolved_at, outcome | One resolution per ticket; ticket must be in resolvable state |
| TicketEvent | event_id, ticket_id, event_type, from_value, to_value, event_at, actor_type, details | Ticket FK; append-only history |
| TicketPolicyCitation | citation_id, ticket_id, version_id, message_id, cited_at, validation_status | Ticket/version FKs; records citation decision |
| TicketKnowledgeArticle | link_id, ticket_id, article_id, linked_at | Ticket/article FKs; unique ticket/article pair |

## Cardinality
- Department 1:N Employee; Department 1:N PolicyDocument (optional policy department).
- PolicyDocument 1:N PolicyVersion; PolicyVersion 1:N KnowledgeArticle.
- Employee 1:N Ticket; Category 1:N Ticket.
- Ticket 1:N Message, Assignment, TicketEvent, TicketPolicyCitation.
- Ticket 1:1 SLA; Ticket 0:1 Resolution.
- Ticket N:M PolicyVersion through TicketPolicyCitation; Ticket N:M KnowledgeArticle through TicketKnowledgeArticle.
