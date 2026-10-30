CREATE TABLE IF NOT EXISTS clean_electricity_regulation
(
    region        TEXT,
    period        INTEGER,
    tech          TEXT,
    vintage       INTEGER,
    emis_comm     TEXT,
    cap           REAL NOT NULL,
    credit_limit  REAL NOT NULL DEFAULT 0,
    credit_cost   REAL NOT NULL DEFAULT 0,
    units         TEXT,
    notes         TEXT,
    PRIMARY KEY (region, period, tech, vintage, emis_comm),
    FOREIGN KEY (period) REFERENCES time_period (period),
    FOREIGN KEY (vintage) REFERENCES time_period (period),
    FOREIGN KEY (emis_comm) REFERENCES commodity (name)
);
