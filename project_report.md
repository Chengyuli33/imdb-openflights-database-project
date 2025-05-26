### Query 1: People Whose Names Start with ‘A’ and Are 5 Characters Long

**🧾 Task**:  
Print the name of all people whose name starts with ‘A’ (case-sensitive), does not end with the lowercase characters 'e' or 'n', and contains exactly 5 characters. Eliminate duplicates (names of actors are not necessarily unique), and print the result in alphabetical order.

**💡 SQL Strategy**:
- Use `LIKE 'A%'` for prefix.
- Use `LENGTH(name) = 5` and `NOT LIKE '%e' OR '%n'` for suffix exclusion.
- Apply `DISTINCT` + `ORDER BY`.

**🧠 SQL Code**:
```sql
hi
```

![添加截图描述性文字](screenshots/query1_result.png)

---

### Query 2: Directors with Movies Rated ≥ 7 After 2000

**🧾 Task**:  
Print the id and name of all directors who have directed some movie whose rating is greater than or equal to 7 and was released after 2000 (2000 not included). Directors are people in crew_in with job = ‘director’. Eliminate duplicates

**💡 SQL Strategy**:
- Use `DISTINCT` to remove duplicates

**🧠 SQL Code**:
```sql
hi
```
![添加截图描述性文字](screenshots/query1_result.png)

### Query 3: Prolific Actors in Highly-Rated Movies

**🧾 Task**:  
For all people who have acted in more than 10 movies that have more than 100k ratings, print their id and name, and the average rating and number of such movies. Order by the number of movies (num_movies) from highest to lowest and secondarily order by name in ascending order. Round average rating to two decimal points.

**💡 SQL Strategy**:
- Use `ROUND(AVG(...), 2)` to round average ratings
- Sort using `ORDER BY num_movies DESC, name ASC`

Round average rating to two decimal points using the ROUND function.

**🧠 SQL Code**:
```sql
hi
```
![添加截图描述性文字](screenshots/query1_result.png)

---


### Query 4: Actors Who Did Not Act in Action Movies Since 2000

**🧾 Task**:  
Print the number of distinct people who have acted in at least one movie, but have not acted in any "Action" movie released in or since 2000.


**💡 SQL Strategy**:
- Use `WITH` clause to create two temporary sets: `all_actors`: all actors; `action_actors`: actors in Action movies since 2000
- Use `LEFT JOIN` to subtract the two sets
- Use `WHERE ... IS NULL` to get those who are **not** in the `action_actors` set


**🧠 SQL Code**:
```sql
hi
```
![添加截图描述性文字](screenshots/query1_result.png)

---


### Query 5: Movies Rated Higher Than All Movies by Directors with Exactly 10 Movies

**🧾 Task**:  
Find the titles and ratings of movies that have a higher rating than all movies directed by a director who has directed exactly 10 movies. Recall that a director is someone in crew_in with job = ‘director’, and that if a movie has not yet been rated (num_ratings=0) the rating is NULL.


**💡 SQL Strategy**:
- Use `GROUP BY` and `HAVING COUNT(*) = 10` to find directors who directed exactly 10 movies
- Use `> ALL (...)` to filter higher-rated movies




**🧠 SQL Code**:
```sql
hi
```
![添加截图描述性文字](screenshots/query1_result.png)

---



### Query 6: Directors with High-Rated Movies and Their Titles

**🧾 Task**:  
For each movie director who has directed at least one movie with more than a million ratings, print the director’s name and a list of all the movie titles this director has directed. The list should separate movie titles by a semicolon and space (‘; ’), and should be in alphabetical order. Order the query result first by the number of movies (descending) and secondly by director id, and name the list of movie titles ‘movies’.


**💡 SQL Strategy**:
- Pre-select eligible directors (`num_ratings > 1000000`)
- Use `STRING_AGG(... ORDER BY ...)` to list titles




**🧠 SQL Code**:
```sql
hi
```
![添加截图描述性文字](screenshots/query1_result.png)

---



### Query 7: Avg Ratings by Director Experience Level

**🧾 Task**:  
Define the experience level of a director as ‘Rising Star’ if they have directed fewer than 5 movies, and 'Veteran' otherwise. For each experience level, print out the average number of ratings (i.e., the num_ratings column) and the average rating of the movies, considering all movies directed by individuals in that experience category. Replace any null values in the num_ratings or rating columns with 0 when calculating the averages. Round the results to two decimal places, and display them in descending order based on the average number of ratings.

**💡 SQL Strategy**:
- Count movies per director, use `CASE` to assign level
- Join back with `crew_in` and `movies`
- Use `COALESCE` to replace nulls, `ROUND` to format





**🧠 SQL Code**:
```sql
hi
```
![添加截图描述性文字](screenshots/query1_result.png)

---


### Query 8: Create OpenFlights Database Schema

**🧾 Task**:  
Create three tables — `Airlines`, `Airports`, and `Routes` — in PostgreSQL, based on the OpenFlights dataset.  
Include appropriate:
- `PRIMARY KEY`s  
- `FOREIGN KEY`s  
- A `CHECK` constraint on the `code_share` column in `Routes`




**🧠 SQL Code**:
```sql
hi
```
![添加截图描述性文字](screenshots/query1_result.png)

---



### Query 9: Cities with International Airports

**🧾 Task**:  
Print the name and country of all cities that contain an international airport, where an international airport is defined as one that flies to at least 5 different countries. Order by city name (primarily) and country name (secondarily) in alphabetical order.


**💡 SQL Strategy**:
- Join `Airports` with `Routes` and `target Airports`
- Filter where source and target countries are different
- Group by source airport and count distinct destination countries






**🧠 SQL Code**:
```sql
hi
```
![添加截图描述性文字](screenshots/query1_result.png)

---



### Query 10: Domestic Cities Served by Airlines

**🧾 Task**:  
For each airline, count the number of distinct domestic cities that are sources of some route and number of distinct domestic cities that are targets of some route. Consider only flights where both the source and target airports are within the airline's home country. Print the name of the airline, home country, the number of distinct source cities it serves, and the number of distinct target cities it serves. Order primarily by country and secondarily by the airline name, both in alphabetical order.


**💡 SQL Strategy**:
- Filter where source & target airports are in same country as airline
- Count `DISTINCT source_city` and `DISTINCT target_city`





**🧠 SQL Code**:
```sql
hi
```
![添加截图描述性文字](screenshots/query1_result.png)

---



### Query 11: Flight Counts Between Kenyan City Pairs

**🧾 Task**:  
For all unique pairs of cities within Kenya, count the number of flights from city A to city B using the routes table, where city A to city B (city A, city B) is considered a different pair from city B to city A (city B, city A). For cities where there are no flights in between, return 0. Order the result by the number of flights in descending order.


**💡 SQL Strategy**:
- Extract all Kenyan cities
- Use `CROSS JOIN` to generate all (A, B) city pairs where A ≠ B
- Count actual flights for each direction using `JOIN`
- Use `LEFT JOIN` + `COALESCE` to return `0` when no flight exists







**🧠 SQL Code**:
```sql
hi
```
![添加截图描述性文字](screenshots/query1_result.png)

---
### Query 12: All Valid Flight Paths from AUH to JFK (Max 3 Legs)

**🧾 Task**:  
A while ago, you won a free ticket to London’s Heathrow Airport (iata LHR) from anywhere in the world. You are now in Abu Dhabi (iata AUH), and have an emergency that requires you get to JFK Airport in New York City as soon as possible (iata JFK). You want to determine all possible routes to reach JFK using a maximum of two paid flights and optionally using your free ticket. You consider the following scenarios:

1. AUH → JFK (1 flight, paid)
2. AUH → X → JFK (2 flights)
3. AUH → X → LHR (free) → JFK. (3 flights, one of which is free to LHR) Do not consider the case where X is JFK.
4. AUH → LHR (free) → X → JFK. (3 flights, one of which is free to LHR) Do not consider the case where X is AUH.

For each possible route of airports, return the path taken (e.g., “AUH;LHR;JFK”). Return in exactly this format (iatas separated by semicolons, no spaces).

To construct paths, please combine city names. Remember that the query needs to account for different flight combinations, so break it into smaller steps which are the scenarios listed above. Eliminate duplicates, and order by increasing number of flights.



**💡 SQL Strategy**:
- Build 4 CTEs for each scenario
- Use `CONCAT()` to format the path
- Use `UNION` and `GROUP BY` to eliminate duplicates
- `ORDER BY num_flights, path`







**🧠 SQL Code**:
```sql
hi
```
![添加截图描述性文字](screenshots/query1_result.png)












