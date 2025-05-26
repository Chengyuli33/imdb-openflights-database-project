-- Airlines Table
CREATE TABLE Airlines (
    id INT,
    name VARCHAR(255),
    alias VARCHAR(255),
    iata CHAR(2),
    icao CHAR(3),
    callsign VARCHAR(255),
    country VARCHAR(255),
    active CHAR(1),
    PRIMARY KEY (id)
);


-- Airports Table
CREATE TABLE Airports (
    id INT,
    name VARCHAR(255),
    city VARCHAR(255),
    country VARCHAR(255),
    iata CHAR(3),
    icao CHAR(4),
    lat NUMERIC(8,6),
    lon NUMERIC(9,6),
    alt INT,
    timezone NUMERIC(3,1),
    dst CHAR(1),
    tz VARCHAR(255),
    PRIMARY KEY (id)
);


-- Routes Table
CREATE TABLE Routes (
    airline_iata CHAR(3),
    airline_id INT,
    src_iata_icao CHAR(4),
    source_id INT,
    target_iata_icao CHAR(4),
    target_id INT,
    code_share CHAR(1) CHECK (code_share IN ('Y', '')),
    equipment CHAR(20),
    PRIMARY KEY (airline_id, source_id, target_id),
    FOREIGN KEY (airline_id) REFERENCES Airlines (id),
    FOREIGN KEY (source_id) REFERENCES Airports (id),
    FOREIGN KEY (target_id) REFERENCES Airports (id)
);
