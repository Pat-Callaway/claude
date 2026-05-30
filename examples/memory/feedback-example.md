---
name: feedback-no-mock-db
description: integration tests must hit a real database, never a mock
metadata:
  type: feedback
---

Never mock the database in integration tests — use a real test database instance.

**Why:** Last quarter, mocked tests passed while the production migration failed silently. The mock didn't reproduce a constraint the real DB enforces. The incident cost half a day of rollback work.

**How to apply:** Any time a test touches data persistence: spin up the test DB container, run migrations, use real queries. Unit tests that don't touch the DB layer are fine to keep isolated.

Related: [[project-test-infra]]
