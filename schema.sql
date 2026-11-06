PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS departments (
    department_id TEXT PRIMARY KEY,
    department_name TEXT NOT NULL UNIQUE,
    created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id TEXT PRIMARY KEY,
    department_id TEXT NOT NULL REFERENCES departments(department_id),
    employee_number TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    employment_type TEXT NOT NULL CHECK (employment_type IN ('FULL_TIME','PART_TIME','CONTRACT','INTERN')),
    hire_date TEXT NOT NULL,
    employment_status TEXT NOT NULL CHECK (employment_status IN ('ACTIVE','INACTIVE','ON_LEAVE')),
    audience_code TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS categories (
    category_id TEXT PRIMARY KEY,
    category_code TEXT NOT NULL UNIQUE CHECK (category_code IN ('BENEFITS','LEAVE','PAYROLL','ONBOARDING','OTHER')),
    category_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS policy_documents (
    policy_id TEXT PRIMARY KEY,
    department_id TEXT REFERENCES departments(department_id),
    policy_code TEXT NOT NULL UNIQUE,
    title TEXT NOT NULL,
    audience TEXT NOT NULL,
    owner_role TEXT NOT NULL,
    lifecycle_state TEXT NOT NULL CHECK (lifecycle_state IN ('DRAFT','PUBLISHED','RETIRED'))
);

CREATE TABLE IF NOT EXISTS policy_versions (
    version_id TEXT PRIMARY KEY,
    policy_id TEXT NOT NULL REFERENCES policy_documents(policy_id),
    version_number INTEGER NOT NULL CHECK (version_number > 0),
    effective_from TEXT NOT NULL,
    effective_to TEXT,
    status TEXT NOT NULL CHECK (status IN ('DRAFT','APPROVED','SUPERSEDED','RETIRED')),
    content TEXT NOT NULL,
    approved_by TEXT,
    UNIQUE(policy_id, version_number),
    CHECK (effective_to IS NULL OR effective_to >= effective_from)
);

CREATE TABLE IF NOT EXISTS knowledge_articles (
    article_id TEXT PRIMARY KEY,
    version_id TEXT NOT NULL REFERENCES policy_versions(version_id),
    title TEXT NOT NULL,
    question_pattern TEXT NOT NULL,
    answer_snippet TEXT NOT NULL,
    keywords TEXT NOT NULL,
    lifecycle_state TEXT NOT NULL CHECK (lifecycle_state IN ('ACTIVE','INACTIVE'))
);

CREATE TABLE IF NOT EXISTS tickets (
    ticket_id TEXT PRIMARY KEY,
    employee_id TEXT NOT NULL REFERENCES employees(employee_id),
    category_id TEXT NOT NULL REFERENCES categories(category_id),
    subject TEXT NOT NULL,
    description TEXT NOT NULL,
    created_at TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('OPEN','IN_PROGRESS','WAITING_FOR_EMPLOYEE','ESCALATED','RESOLVED','CLOSED')),
    priority TEXT NOT NULL CHECK (priority IN ('LOW','MEDIUM','HIGH','CRITICAL')),
    is_sensitive INTEGER NOT NULL DEFAULT 0 CHECK (is_sensitive IN (0,1)),
    issue_type TEXT
);

CREATE TABLE IF NOT EXISTS messages (
    message_id TEXT PRIMARY KEY,
    ticket_id TEXT NOT NULL REFERENCES tickets(ticket_id),
    sender_employee_id TEXT REFERENCES employees(employee_id),
    sender_type TEXT NOT NULL CHECK (sender_type IN ('EMPLOYEE','SYSTEM','HR','MANAGER')),
    message_type TEXT NOT NULL CHECK (message_type IN ('QUESTION','ACKNOWLEDGEMENT','CLARIFICATION','ANSWER','RESOLUTION','NOTE')),
    body TEXT NOT NULL,
    created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS assignments (
    assignment_id TEXT PRIMARY KEY,
    ticket_id TEXT NOT NULL REFERENCES tickets(ticket_id),
    assigned_to_employee_id TEXT REFERENCES employees(employee_id),
    assigned_queue TEXT NOT NULL,
    assigned_at TEXT NOT NULL,
    unassigned_at TEXT,
    assignment_reason TEXT NOT NULL,
    is_current INTEGER NOT NULL DEFAULT 1 CHECK (is_current IN (0,1)),
    CHECK (unassigned_at IS NULL OR unassigned_at >= assigned_at)
);

CREATE TABLE IF NOT EXISTS slas (
    sla_id TEXT PRIMARY KEY,
    ticket_id TEXT NOT NULL UNIQUE REFERENCES tickets(ticket_id),
    calendar_code TEXT NOT NULL,
    first_response_due_at TEXT NOT NULL,
    resolution_due_at TEXT NOT NULL,
    first_response_at TEXT,
    resolved_at TEXT,
    sla_status TEXT NOT NULL CHECK (sla_status IN ('ON_TRACK','AT_RISK','BREACHED','MET','STOPPED'))
);

CREATE TABLE IF NOT EXISTS resolutions (
    resolution_id TEXT PRIMARY KEY,
    ticket_id TEXT NOT NULL UNIQUE REFERENCES tickets(ticket_id),
    resolution_code TEXT NOT NULL,
    resolution_summary TEXT NOT NULL,
    resolved_by TEXT,
    resolved_at TEXT NOT NULL,
    outcome TEXT NOT NULL CHECK (outcome IN ('ANSWERED','REFERRED_TO_HR','WITHDRAWN','DUPLICATE'))
);

CREATE TABLE IF NOT EXISTS ticket_events (
    event_id TEXT PRIMARY KEY,
    ticket_id TEXT NOT NULL REFERENCES tickets(ticket_id),
    event_type TEXT NOT NULL,
    from_value TEXT,
    to_value TEXT,
    event_at TEXT NOT NULL,
    actor_type TEXT NOT NULL,
    details TEXT
);

CREATE TABLE IF NOT EXISTS ticket_policy_citations (
    citation_id TEXT PRIMARY KEY,
    ticket_id TEXT NOT NULL REFERENCES tickets(ticket_id),
    version_id TEXT NOT NULL REFERENCES policy_versions(version_id),
    message_id TEXT REFERENCES messages(message_id),
    cited_at TEXT NOT NULL,
    validation_status TEXT NOT NULL CHECK (validation_status IN ('VALID','OBSOLETE','NOT_YET_EFFECTIVE','AUDIENCE_MISMATCH','UNSUPPORTED'))
);

CREATE TABLE IF NOT EXISTS ticket_knowledge_articles (
    link_id TEXT PRIMARY KEY,
    ticket_id TEXT NOT NULL REFERENCES tickets(ticket_id),
    article_id TEXT NOT NULL REFERENCES knowledge_articles(article_id),
    linked_at TEXT NOT NULL,
    UNIQUE(ticket_id, article_id)
);

CREATE INDEX IF NOT EXISTS idx_tickets_status ON tickets(status);
CREATE INDEX IF NOT EXISTS idx_tickets_category ON tickets(category_id);
CREATE INDEX IF NOT EXISTS idx_policy_effective ON policy_versions(policy_id, effective_from, effective_to);
CREATE INDEX IF NOT EXISTS idx_messages_ticket_time ON messages(ticket_id, created_at);
CREATE INDEX IF NOT EXISTS idx_events_ticket_time ON ticket_events(ticket_id, event_at);
