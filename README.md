# openclaw-realestate

OpenClaw skills for automating rental property search in Vietnam.

Searches listings on Chotot, collects owner contacts, and manages the full workflow from discovery to viewing scheduling — all through Telegram or Zalo.

## Skills

| Skill | Description |
|---|---|
| `skills/listing-search.md` | Search chotot.com for rentals matching your criteria, save to local DB |
| `skills/approval-manager.md` | Review new listings and approve or reject them before any contact is made |
| `skills/zalo-agent.md` | Contact approved listing owners via Zalo, track replies, schedule viewings |
| `skills/db-admin.md` | Administrative operations on the listings database (clear, reset) |

## Workflow

```
Search → Approve → Contact → Schedule
```

1. **Search** — finds listings on Chotot, saves to SQLite. Phone numbers are not extracted yet.
2. **Approve** — you review each listing and approve or reject it.
3. **Contact** — for approved listings, opens the listing page in Chrome to reveal the hidden phone number, then sends a Zalo message to the owner.
4. **Schedule** — tracks replies and coordinates viewing times.

## Requirements

- [OpenClaw](https://openclaw.ai) gateway running locally
- Zalo channel configured in OpenClaw
- OpenAI API key (for voice transcription via `openai-whisper-api` skill)
- Chrome browser (for phone number reveal on listing pages)

## Setup

1. Clone into your OpenClaw workspace:

```bash
git clone git@github.com:arisonadim/openclaw-realestate.git ~/.openclaw/workspace
```

2. Tell your agent to start searching:

```
Search for 2-bedroom apartments for rent in District 2, Ho Chi Minh City, under 15 million VND/month
```

## License

MIT
