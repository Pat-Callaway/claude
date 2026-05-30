---
name: reference-compliance-docs
description: internal compliance requirements for session token storage live in Notion
metadata:
  type: reference
---

The data-residency and session token compliance requirements are documented in Notion at the "Security & Compliance" workspace, page "2026 Token Storage Requirements". This is the authoritative source — not the Jira tickets, which are summaries only.

Pipeline bugs are tracked in Linear under project "INFRA". Sprint board is at Linear > INFRA > Active Cycles.

Oncall latency dashboard: Grafana at grafana.internal/d/api-latency — check this before merging anything that touches the request path.

Related: [[project-auth-rewrite]]
