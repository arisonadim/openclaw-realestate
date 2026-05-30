# Approval Manager

## Purpose

Review newly discovered listings and request user approval before any contact is made.

This skill is responsible only for approval workflow.

---

# Dependencies

Required schema:

* ../schemas/listing-schema.md

Database:

* data/listings.db

---

# Responsibilities

* Load listings with status = new
* Present listings to the user
* Collect approval decisions
* Update listing status

---

# Selection Rules

Only work with listings where:

```text
status = new
```

Ignore all other records.

---

# Presentation Format

When presenting listings:

Show:

* title
* price
* district
* address
* phone (if available)
* notes (if available)
* url

Keep summaries short.

Do not show database internals.

---

# User Decisions

Supported actions:

## Approve

When user approves a listing:

```text
status = approved
```

## Reject

When user rejects a listing:

```text
status = rejected
```

## Skip

If user does not make a decision:

```text
status remains unchanged
```

---

# Bulk Approval

Support approving multiple listings.

Examples:

```text
Approve: 1, 3, 5

Reject: 2, 4
```

Update all affected records.

---

# Rules

Never:

* contact owners
* send Zalo messages
* schedule viewings
* modify messages table
* create new listings

---

# Output

After processing approvals:

Show:

* approved count
* rejected count
* remaining new listings

Example:

```text
Approved: 3
Rejected: 2
Remaining: 7
```

---

# Handoff

Listings with:

```text
status = approved
```

may be processed by:

```text
skills/zalo-agent.md
```

No other listings may be contacted.

