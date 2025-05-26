
-- Query 9: International Airports
WITH international_airports AS (
    SELECT a.city, a.country
    FROM Airports a
    JOIN Routes r ON a.id = r.source_id
    JOIN Airports dest ON r.target_id = dest.id AND a.country <> dest.country
    GROUP BY a.id, a.city, a.country
    HAVING COUNT(DISTINCT dest.country) >= 5
)
SELECT DISTINCT city, country
FROM international_airports
ORDER BY city, country;

-- Query 10: Domestic Cities by Airline
SELECT a.name AS airline_name, a.country AS home_country,
    COUNT(DISTINCT s.city) AS distinct_source_cities,
    COUNT(DISTINCT t.city) AS distinct_target_cities
FROM airlines a
JOIN routes r ON a.id = r.airline_id
JOIN airports s ON r.source_id = s.id
JOIN airports t ON r.target_id = t.id
WHERE a.country = s.country AND a.country = t.country
GROUP BY a.id, a.name, a.country
ORDER BY a.country, a.name;
