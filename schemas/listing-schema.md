# Listing Schema

## Purpose

This document defines the database schema and status rules for the listing workflow.

The SQLite database is the single source of truth.

Skills must read and update database records instead of relying on memory.

---

# Initialization

If the database does not exist, create it before first use:

```bash
mkdir -p data
sqlite3 data/listings.db < scripts/init-db.sql
```

Or instruct the agent: "Initialize the listings database."

---

# Table: listings

Stores real estate listings found on Vietnamese listing websites.

## Columns

| Column           | Type    | Description                   |
| ---------------- | ------- | ----------------------------- |
| id               | INTEGER | Primary key                   |
| url              | TEXT    | Original listing URL          |
| title            | TEXT    | Listing title                 |
| price            | INTEGER | Monthly rent in VND           |
| city             | TEXT    | City                          |
| district         | TEXT    | District or area              |
| ward             | TEXT    | Ward                          |
| address          | TEXT    | Exact or approximate address  |
| area             | REAL    | Area in square meters         |
| bedrooms         | INTEGER | Number of bedrooms            |
| bathrooms        | INTEGER | Number of bathrooms           |
| description      | TEXT    | Full listing description      |
| phone            | TEXT    | Owner or agent phone number   |
| contact_name     | TEXT    | Owner, agent, or contact name |
| publication_date | TEXT    | Date listing was published    |
| last_seen_at     | TEXT    | Last time listing was found   |
| created_at       | TEXT    | Record creation timestamp     |
| status           | TEXT    | Current workflow status       |
| viewing_time     | TEXT    | Agreed viewing time, if any   |
| notes            | TEXT    | Human or agent notes          |

---

## Status values

The `status` field must use only one of these values:

```text
new
approved
rejected
contacted
replied
scheduled
viewed
closed
```

## Status meanings

| Status    | Meaning                                            |
| --------- | -------------------------------------------------- |
| new       | Listing was found and is waiting for user approval |
| approved  | User approved this listing for contact             |
| rejected  | User rejected this listing                         |
| contacted | First message was sent to the contact              |
| replied   | Contact replied in Zalo                            |
| scheduled | Viewing time was confirmed                         |
| viewed    | Viewing was completed                              |
| closed    | Listing is no longer active or conversation ended  |

---

## Listing rules

* `url` should be treated as the main deduplication key.
* Do not insert duplicate listings with the same `url`.
* Do not contact anyone unless `status = approved`.
* New listings must be created with `status = new`.
* Rejected listings must not be contacted.
* Do not delete records automatically.
* Do not overwrite `notes` unless explicitly instructed.
* If a listing disappears from the website, set `status = closed` and add a note.

---

# Table: messages

Stores communication history with listing contacts.

## Columns

| Column     | Type    | Description        |
| ---------- | ------- | ------------------ |
| id         | INTEGER | Primary key        |
| listing_id | INTEGER | Related listing id |
| direction  | TEXT    | Message direction  |
| text       | TEXT    | Message content    |
| created_at | TEXT    | Message timestamp  |

---

## Direction values

The `direction` field must use only one of these values:

```text
incoming
outgoing
```

## Message rules

* Every sent Zalo message must be saved with `direction = outgoing`.
* Every received Zalo reply must be saved with `direction = incoming`.
* `listing_id` must reference an existing listing.
* Do not store messages without a related listing when possible.

---

# Workflow

```text
new
  ↓
approved
  ↓
contacted
  ↓
replied
  ↓
scheduled
  ↓
viewed
  ↓
closed
```

Alternative paths:

```text
new → rejected
approved → closed
contacted → closed
replied → closed
scheduled → closed
```

---

# Agent rules

1. Always check current listing status before taking action.
2. Never contact a listing with `status = new` or `status = rejected`.
3. Ask the user for approval before changing `new` to `approved`.
4. After sending the first message, set `status = contacted`.
5. After receiving a reply, set `status = replied`.
6. After confirming a viewing time, set `status = scheduled` and fill `viewing_time`.
7. After the viewing is done, set `status = viewed`.
8. If the listing is unavailable, duplicated, or no longer relevant, set `status = closed`.
9. Keep all important details in `notes`.
10. The database is authoritative; do not rely on chat memory for listing state.

