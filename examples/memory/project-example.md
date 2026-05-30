---
name: project-auth-rewrite
description: auth middleware rewrite is compliance-driven, not tech-debt — scope decisions favor compliance over ergonomics
metadata:
  type: project
---

The old auth middleware is being replaced by 2026-06-15. Legal flagged it for storing session tokens in a way that violates the new data-residency compliance requirements.

**Why:** This is not a tech-debt cleanup — it is a hard compliance deadline. Scope creep (e.g. "while we're in here, let's also refactor X") is not acceptable. Every change must be justifiable as necessary for compliance.

**How to apply:** When suggesting changes to auth-related code, prioritize correctness and compliance over elegance. Flag any suggestion that goes beyond the compliance requirement as out of scope.

Related: [[reference-compliance-docs]]
