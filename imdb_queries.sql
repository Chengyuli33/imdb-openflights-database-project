
-- Query 1
SELECT DISTINCT name FROM people
WHERE name LIKE 'A%' AND LENGTH(name) = 5 AND NOT (name LIKE '%e' OR name LIKE '%n')
ORDER BY name;

-- Query 2
SELECT DISTINCT p.id, p.name
FROM crew_in c
JOIN people p ON c.person_id = p.id
JOIN movies m ON c.movie_id = m.id
WHERE c.job = 'director' AND m.rating >= 7 AND m.release_year > 2000;

-- Query 3
SELECT p.id, p.name, ROUND(AVG(m.rating), 2) AS avg_rating, COUNT(*) AS num_movies
FROM cast_in c
JOIN movies m ON c.movie_id = m.id
JOIN people p ON c.person_id = p.id
WHERE m.num_ratings > 100000
GROUP BY p.id, p.name
HAVING COUNT(*) > 10
ORDER BY num_movies DESC, p.name;

-- Query 4
WITH all_actors AS (
    SELECT DISTINCT c.person_id FROM cast_in c
),
action_actors AS (
    SELECT DISTINCT c.person_id FROM cast_in c
    JOIN movies m ON c.movie_id = m.id
    JOIN movie_genres g ON m.id = g.movie_id
    WHERE g.genre = 'Action' AND m.release_year >= 2000
)
SELECT COUNT(*) AS num_actors
FROM all_actors a
LEFT JOIN action_actors aa ON a.person_id = aa.person_id
WHERE aa.person_id IS NULL;

-- Query 5
WITH directors_with_10_movies AS (
    SELECT c.person_id AS director_id
    FROM crew_in c
    WHERE c.job = 'director'
    GROUP BY c.person_id
    HAVING COUNT(*) = 10
),
director_movies_rating AS (
    SELECT m.rating
    FROM directors_with_10_movies d
    JOIN crew_in c ON d.director_id = c.person_id
    JOIN movies m ON c.movie_id = m.id
)
SELECT m.title, m.rating
FROM movies m
WHERE m.rating > ALL (
    SELECT dm.rating FROM director_movies_rating dm WHERE dm.rating IS NOT NULL
);
