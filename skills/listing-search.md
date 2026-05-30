# Listing Search Skill

## Purpose

Search Vietnamese real estate websites for rental listings matching user criteria.

Collect listing information and save normalized records into the listings database.

This skill is responsible only for discovery and database updates.

This skill must never contact owners.

---

# Dependencies

Required schema:

../schemas/listing-schema.md

Always use status values defined in listing-schema.md.
Never invent new fields or statuses.

## Responsibilities

* Search supported listing websites.
* Extract listing information.
* Normalize collected data.
* Avoid duplicates.
* Store new listings.
* Update existing listings.
* Mark new records for approval.

---

## Supported Websites

* chotot.com
* nha.chotot.com

---

## Search Parameters

Use filters provided by the user:

* city
* district
* ward
* property type
* monthly rent
* bedrooms
* area
* keywords

If a parameter is missing, do not assume values.

---

## Data Extraction

Extract when available:

* title
* url
* price
* city
* district
* ward
* address
* area
* bedrooms
* bathrooms
* description
* phone (save as NULL if masked or hidden — do not save masked values like `090xxxxxx`)
* contact_name
* publication_date

---

## Database Rules

Before inserting a listing:

1. Check if URL already exists.
2. Check if listing title and address match an existing record.
3. Do not create duplicates.

For new listings:

* status = "new"
* created_at = current UTC timestamp (ISO 8601)
* last_seen_at = current UTC timestamp (ISO 8601)

For existing listings:

* update changed fields
* update last_seen_at

---

## Quality Rules

Ignore listings when:

* listing is deleted
* listing is unavailable
* price is missing
* location is missing
* listing appears fraudulent
* listing is older than user limit

Prefer listings with:

* exact location
* clear photos
* recent publication date
* complete description

---

## Output

After search completion provide:

* total listings found
* new listings added
* existing listings updated
* duplicate listings skipped

Do not display full results unless requested.

Store results in the database.

---

## Restrictions

Never:

* contact owners
* negotiate
* schedule viewings
* modify approval status
* delete records

Those actions belong to other skills.

