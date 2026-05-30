# DB Admin

## Purpose

Administrative operations on the listings database.

All destructive operations require explicit user confirmation before execution.

---

# Clear All Listings

Deletes all rows from `listings` and `messages`.

## Trigger

User requests to clear, reset, or wipe the listings database.

## Steps

1. Count current rows:

```sql
SELECT COUNT(*) FROM listings;
SELECT COUNT(*) FROM messages;
```

2. Show the user:

```
⚠️ This will permanently delete:
  - X listings
  - Y messages

Reply YES to confirm, anything else to cancel.
```

3. Wait for user reply.
   - If reply is exactly `YES` (case-insensitive) → proceed.
   - Any other reply → cancel and confirm cancellation.

4. On confirmation:

```sql
DELETE FROM listings;
DELETE FROM messages;
```

5. Report:

```
Cleared: X listings, Y messages deleted.
```

---

# Rules

* Never clear the database without going through the confirmation step.
* Never interpret ambiguous replies as confirmation.
* Do not clear individual tables separately unless the user explicitly requests it.
