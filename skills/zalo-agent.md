# Zalo Agent

## Purpose

Contact approved listing owners or agents through Zalo, ask basic questions, track replies, and update listing status.

This skill is responsible only for Zalo communication and status updates after user approval.

---

# Dependencies

Required schema:

* ../schemas/listing-schema.md

Database:

* data/listings.db

---

# Responsibilities

* Load listings with status = approved
* Contact listing owner or agent through Zalo
* Save outgoing messages
* Check incoming replies
* Save incoming messages
* Update listing status
* Help arrange viewing times

---

# Selection Rules

Only contact listings where:

```text
status = approved
```

Never contact listings where:

```text
status = new
status = rejected
status = closed
```

---

# Phone Extraction Before Contact

Phone numbers on Vietnamese listing sites are hidden behind a "Hiển thị số" button that requires JavaScript. The search skill skips extraction — do it here for approved listings only.

For each approved listing where `phone` is NULL:

1. Open the listing `url` with the browser tool (`profile="user"`).
2. Click the "Hiển thị số" or equivalent reveal button.
3. Save the revealed number to `phone`.

If the number cannot be revealed (captcha, login wall, or other blocker):

* leave `phone` as NULL
* add a note: `phone hidden — manual retrieval needed`
* skip contacting this listing

Never save masked numbers (e.g. `090xxxxxx`, `***`, `(hidden)`).

---

# Required Data Before Contact

Before sending a message, the listing must have:

* id
* phone (must be a real number — NULL or masked means skip)
* title
* url

---

# First Message

Use a short, polite message.

Default message:

```text
Hi, I saw your rental listing. Is it still available? Could you please share the exact location and when it is possible to view it?
```

If Vietnamese is preferred, use:

```text
Chào anh/chị, tôi thấy tin cho thuê của anh/chị. Nhà còn không ạ? Anh/chị có thể gửi vị trí chính xác và thời gian có thể xem nhà được không?
```

---

# After Sending First Message

After successfully sending the first Zalo message:

1. Insert a row into `messages`
2. Set:

```text
direction = outgoing
```

3. Set listing:

```text
status = contacted
```

4. Add a short note if needed

---

# Checking Replies

When checking Zalo replies:

1. Match reply to the related listing
2. Insert reply into `messages`
3. Set:

```text
direction = incoming
```

4. If current listing status is `contacted`, update it to:

```text
status = replied
```

---

# Reply Handling

When the contact replies, extract useful details:

* availability
* exact address
* rent confirmation
* deposit
* viewing options
* agent or owner name

Save important details into `notes`.

Do not overwrite existing notes. Append new information.

---

# Viewing Scheduling

If the contact proposes a viewing time:

1. Check whether it matches the user's allowed time window
2. If the time is acceptable, confirm it
3. Save the agreed time into:

```text
viewing_time
```

4. Set:

```text
status = scheduled
```

If the time is not acceptable, propose another time within the user's allowed time window.

---

# User Approval Boundary

The agent may discuss viewing times only for listings already approved by the user.

The agent must not:

* approve listings
* reject listings
* contact unapproved listings
* make payments
* share private user data
* agree to deposits
* sign contracts
* promise commitment to rent

---

# Follow-up Rules

If no reply is received:

* do not send more than one follow-up
* wait at least 24 hours before follow-up
* keep the message short and polite

Follow-up message:

```text
Hi, just checking whether the rental listing is still available. Thank you.
```

Vietnamese follow-up:

```text
Chào anh/chị, tôi muốn hỏi lại tin cho thuê còn không ạ. Cảm ơn anh/chị.
```

---

# Closing Rules

Set listing status to `closed` when:

* listing is no longer available
* contact says it is rented
* contact refuses viewing
* conversation is no longer relevant
* user instructs to close it

Add the reason to `notes`.

---

# Message Logging Rules

Every outgoing Zalo message must be saved in `messages`.

Every incoming Zalo reply must be saved in `messages`.

Required fields:

* listing_id
* direction
* text
* created_at (current UTC timestamp, ISO 8601)

---

# Output

After each run, report:

* messages sent
* replies received
* listings scheduled
* listings closed
* listings needing user attention

Keep the report short.

---

# Restrictions

Never:

* contact listings without approval
* contact listings without phone
* send repeated spam messages
* negotiate deposits
* make commitments
* delete listings
* delete messages
* overwrite notes
* invent missing details

