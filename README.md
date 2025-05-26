# IMDB & OpenFlights SQL Database Project


This project involves querying the IMDB dataset and designing a PostgreSQL database based on OpenFlights flight data.


It involves:
- Querying a PostgreSQL-hosted IMDB dataset using advanced SQL (joins, subqueries, aggregations, CTEs).
- Designing a normalized relational schema for the OpenFlights dataset (Airlines, Airports, Routes).
- Uploading data into AWS RDS PostgreSQL and performing complex analytics such as airport connectivity, domestic flights, and custom pathfinding.
- Writing safe and optimized SQL queries including usage of `WITH`, `COALESCE`, `CASE`, `STRING_AGG`, and multi-step joins.


## 📁 File Structure

- `imdb_queries.sql`: SQL queries over the IMDb dataset on an AWS RDS PostgreSQL database.

- `openflights_schema.sql`: DDL statements to define the OpenFlights dataset schema.

- `openflights_queries.sql`: Analytical SQL queries on the OpenFlights data.

- `project_report.md`: For detailed question breakdowns and query logic.



## 🛠️ Tech Stack

- PostgreSQL
- AWS RDS
- SQL (CTE, Joins, Aggregation)
- DataGrip (JetBrains)
