
-- Query 9: International Airports
WITH
international_airports AS (
    SELECT
        a.city,
        a.country
    FROM
        Airports a
    JOIN
        Routes r ON a.id = r.source_id
    JOIN
        Airports dest ON r.target_id = dest.id
        AND a.country <> dest.country
    GROUP BY
        a.id,
        a.city,
        a.country
    HAVING
        COUNT(DISTINCT dest.country) >= 5  -- fly to at least 5 different countries
)
SELECT DISTINCT
    city,
    country
FROM
    international_airports
ORDER BY
    city,
    country;


-- Query 10: Domestic Cities by Airline
SELECT
    a.name AS airline_name,
    a.country AS home_country,
    COUNT(DISTINCT s.city) AS distinct_source_cities,
    COUNT(DISTINCT t.city) AS distinct_target_cities
FROM Airlines a
JOIN Routes r ON a.id = r.airline_id
JOIN Airports s ON r.source_id = s.id
JOIN Airports t ON r.target_id = t.id
WHERE a.country = s.country AND a.country = t.country
GROUP BY a.id, a.name, a.country
ORDER BY a.country, a.name;



-- Query 11
WITH
kenyan_cities AS (  -- find all cities within Kenya
    SELECT DISTINCT city
    FROM airports
    WHERE country = 'Kenya'
),
all_kenyan_pairs AS (  -- find all city pairs in within Kenya
    SELECT
        k1.city AS city_A,
        k2.city AS city_B
    FROM
        kenyan_cities k1
    CROSS JOIN
        kenyan_cities k2
    WHERE k1.city <> k2.city  -- city pair refers to different cities
),
flights_A_to_B AS (  -- find flights from city A to city B
    SELECT
        src.city AS city_A,
        dest.city AS city_B,
        COUNT(*) AS num_flights
    FROM
        routes r
    JOIN
        airports src ON r.source_id = src.id AND src.country = 'Kenya'
    JOIN
        airports dest ON r.target_id = dest.id AND dest.country = 'Kenya'
    GROUP BY
        src.city,
        dest.city
)
SELECT
    kp.city_A,
    kp.city_B,
    COALESCE(fab.num_flights, 0) AS num_flights
FROM
    all_kenyan_pairs kp
LEFT JOIN
    flights_A_to_B fab
    ON kp.city_A = fab.city_A AND kp.city_B = fab.city_B
ORDER BY
    num_flights DESC;



-- Query 12
WITH
scenario_1 AS (
    SELECT DISTINCT
        1 AS num_flights,  -- number of flights is 1
        'AUH;JFK' AS path  -- return the path separated by semicolons
    FROM Routes r
    -- the first leg of the flight:
    JOIN Airports src ON r.source_id = src.id AND src.iata = 'AUH'  -- match routes where the source airport is AUH
    JOIN Airports dest ON r.target_id = dest.id AND dest.iata = 'JFK'  -- match routes where the target airport is JFK
),
scenario_2 AS (
    SELECT DISTINCT
        2 AS num_flights,  -- number of flights is 2
        CONCAT('AUH;', x.iata, ';JFK') AS path  -- return the path separated by semicolons
    FROM Routes r1
    -- the first leg of the flight:
    JOIN Airports src ON r1.source_id = src.id AND src.iata = 'AUH'  -- match routes where the source airport is AUH
    JOIN Airports x ON r1.target_id = x.id  -- match routes where the target airport is X
    -- the second leg of the flight:
    JOIN Routes r2 ON r2.source_id = x.id  -- match routes where the source airport is X
    JOIN Airports jfk ON r2.target_id = jfk.id AND jfk.iata = 'JFK'  -- match routes where the target airport is JFK
    WHERE
        x.iata != 'JFK'
),
scenario_3 AS (
    SELECT DISTINCT
        3 AS num_flights,  -- number of flights is 3
        CONCAT('AUH;', x.iata, ';LHR;JFK') AS path  -- return the path separated by semicolons
    FROM Routes r1
    -- the first leg of the flight:
    JOIN Airports src ON r1.source_id = src.id AND src.iata = 'AUH'  -- match routes where the source airport is AUH
    JOIN Airports x ON r1.target_id = x.id  -- match routes where the target airport is X
    -- the second leg of the flight:
    JOIN Routes r2 ON r2.source_id = x.id  -- match routes where the source airport is X
    JOIN Airports lhr ON r2.target_id = lhr.id AND lhr.iata = 'LHR'  -- match routes where the target airport is LHR
    -- the third leg of the flight:
    JOIN Routes r3 ON r3.source_id = lhr.id  -- match routes where the source airport is LHR
    JOIN Airports jfk ON r3.target_id = jfk.id AND jfk.iata = 'JFK'  -- match routes where the source airport is JFK
    WHERE
        x.iata != 'JFK'
),
scenario_4 AS (
    SELECT DISTINCT
        3 AS num_flights,  -- number of flights is 3
        CONCAT('AUH;LHR;', x.iata, ';JFK') AS path  -- return the path separated by semicolons
    FROM Routes r1
    -- the first leg of the flight:
    JOIN Airports auh ON r1.source_id = auh.id AND auh.iata = 'AUH'  -- match routes where the source airport is AUH
    JOIN Airports lhr ON r1.target_id = lhr.id AND lhr.iata = 'LHR'  -- match routes where the target airport is LHR
    -- the second leg of the flight:
    JOIN Routes r2 ON r2.source_id = lhr.id  -- match routes where the source airport is LHR
    JOIN Airports x ON r2.target_id = x.id  -- match routes where the target airport is X
    -- the third leg of the flight:
    JOIN Routes r3 ON r3.source_id = x.id  -- match routes where the source airport is AUH
    JOIN Airports jfk ON r3.target_id = jfk.id AND jfk.iata = 'JFK'  -- match routes where the target airport is JFK
    WHERE
        x.iata != 'AUH'
)
SELECT
    num_flights,
    path
FROM (
    SELECT * FROM scenario_1
    UNION
    SELECT * FROM scenario_2
    UNION
    SELECT * FROM scenario_3
    UNION
    SELECT * FROM scenario_4
) AS combined
GROUP BY
    num_flights,
    path
ORDER BY
    num_flights,
    path;

