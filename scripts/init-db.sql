CREATE TABLE IF NOT EXISTS listings (
    id               INTEGER PRIMARY KEY,
    url              TEXT,
    title            TEXT,
    price            INTEGER,
    city             TEXT,
    district         TEXT,
    ward             TEXT,
    address          TEXT,
    area             REAL,
    bedrooms         INTEGER,
    bathrooms        INTEGER,
    description      TEXT,
    phone            TEXT,
    contact_name     TEXT,
    publication_date TEXT,
    last_seen_at     TEXT,
    created_at       TEXT,
    status           TEXT,
    viewing_time     TEXT,
    notes            TEXT
);

CREATE TABLE IF NOT EXISTS messages (
    id         INTEGER PRIMARY KEY,
    listing_id INTEGER,
    direction  TEXT,
    text       TEXT,
    created_at TEXT
);
