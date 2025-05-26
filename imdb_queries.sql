
-- Query 1
SELECT
    DISTINCT name
FROM
    people
WHERE
    name LIKE 'A%'
    AND LENGTH(name) = 5
    AND NOT (name LIKE '%e' OR name LIKE '%n')
ORDER BY
    name;


-- Query 2
SELECT
    DISTINCT p.id, p.name
FROM
    crew_in c
    JOIN people p ON c.person_id = p.id
    JOIN movies m ON c.movie_id = m.id
WHERE
    c.job = 'director'
    AND m.rating >= 7
    AND m.release_year > 2000;


-- Query 3
SELECT
    p.id,
    p.name,
    ROUND(AVG(m.rating), 2) AS avg_rating,
    COUNT(*) AS num_movies
FROM cast_in c
    JOIN movies m ON c.movie_id = m.id
    JOIN people p ON c.person_id = p.id
WHERE
    m.num_ratings > 100000
GROUP BY
    p.id,
    p.name
HAVING
    COUNT(*) > 10
ORDER BY
    num_movies DESC,
    p.name;


-- Query 4
WITH
all_actors AS (  -- people who have ever acted in at least one movie:
    SELECT DISTINCT c.person_id
    FROM cast_in c
),
action_actors AS (  -- people who have ever acted in "Action" movie released in or since 2000:
    SELECT DISTINCT c.person_id
    FROM cast_in c
        JOIN movies m ON c.movie_id = m.id
        JOIN movie_genres g ON m.id = g.movie_id
    WHERE g.genre = 'Action'
      AND m.release_year >= 2000
)
SELECT
    COUNT(*) AS num_actors
FROM
    all_actors a
LEFT JOIN
        action_actors aa ON a.person_id = aa.person_id
WHERE aa.person_id IS NULL;


-- Query 5
WITH
directors_with_10_movies AS (  -- find the id of the director who has directed exactly 10 movies
    SELECT
        c.person_id AS director_id
    FROM
        crew_in c
    WHERE
        c.job = 'director'
    GROUP BY
        c.person_id
    HAVING
        COUNT(*) = 10
),
director_movies_rating AS (  -- find the rating of 10_movies_directors
    SELECT
        m.rating
    FROM
        directors_with_10_movies d  -- NOTE: JOIN extended directors_with_10_movies table with more columns.
    JOIN
        crew_in c ON d.director_id = c.person_id
    JOIN
        movies m ON c.movie_id = m.id
)
SELECT
    m.title,
    m.rating
FROM
    movies m
WHERE
    m.rating > ALL (  -- rating should higher than all movies in the following subquery:
        SELECT
            dm.rating
        FROM
            director_movies_rating dm
        WHERE
            dm.rating IS NOT NULL -- exclude NULL rating
    );


-- Query 6
WITH directors_with_hit AS (
    SELECT DISTINCT c.person_id
    FROM crew_in c
    JOIN movies m ON c.movie_id = m.id
    WHERE c.job = 'director' AND m.num_ratings > 1000000
)
SELECT
    c.person_id AS director_id,
    p.name AS director_name,
    STRING_AGG(m.title, '; ' ORDER BY m.title) AS movies,
    COUNT(m.id) AS movie_count
FROM crew_in c
JOIN people p ON c.person_id = p.id
JOIN movies m ON c.movie_id = m.id
JOIN directors_with_hit dwh ON dwh.person_id = c.person_id
WHERE c.job = 'director'
GROUP BY c.person_id, p.name
ORDER BY movie_count DESC, c.person_id;


-- Query 7
WITH movie_counts_per_director AS (
    SELECT
        c.person_id AS director_id,
        COUNT(DISTINCT c.movie_id) AS director_total_movie_count
    FROM crew_in c
    WHERE c.job = 'director'
    GROUP BY c.person_id
),
experience_level AS (
    SELECT
        director_id,
        CASE
            WHEN director_total_movie_count < 5 THEN 'Rising Star'
            ELSE 'Veteran'
        END AS experience_level
    FROM movie_counts_per_director
)
SELECT
    el.experience_level,
    ROUND(AVG(COALESCE(m.num_ratings, 0)), 2) AS avg_num_ratings,
    ROUND(AVG(COALESCE(m.rating, 0)), 2) AS avg_rating
FROM experience_level el
JOIN crew_in c ON c.person_id = el.director_id
JOIN movies m ON c.movie_id = m.id
WHERE c.job = 'director'
GROUP BY el.experience_level
ORDER BY avg_num_ratings DESC;


