/* Inner Join */
SELECT
  t.tpep_pickup_datetime,
  t.tpep_dropoff_datetime,
  t.total_amount,
  CONCAT(zpu."Borough", ' / ', zpu."Zone") AS "pick_up_loc",
  CONCAT(zdo."Borough", ' / ', zdo."Zone") AS "drop_off_loc"
FROM
  yellow_taxi_data t,
  zones zpu,
  zones zdo
WHERE
  t."PULocationID" = zpu."LocationID"
  AND t."DOLocationID" = zdo."LocationID"
LIMIT
  100;

/* Explicit inner join */
SELECT
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  total_amount,
  CONCAT(zpu."Borough", ' | ', zpu."Zone") AS "pickup_loc",
  CONCAT(zdo."Borough", ' | ', zdo."Zone") AS "dropoff_loc"
FROM
  yellow_taxi_data t
  JOIN
  -- or INNER JOIN but it's less used, when writing JOIN, postgreSQL understands implicitly that we want to use an INNER JOIN
  zones zpu ON t."PULocationID" = zpu."LocationID"
  JOIN zones zdo ON t."DOLocationID" = zdo."LocationID"
LIMIT
  100;

/* Checking for records with NULL Location IDs in the Yellow Taxi table */
SELECT
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  total_amount,
  "PULocationID",
  "DOLocationID"
FROM
  yellow_taxi_data
WHERE
  "PULocationID" IS NULL
  OR "DOLocationID" IS NULL
LIMIT
  10;

SELECT
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  total_amount,
  "PULocationID",
  "DOLocationID"
FROM
  yellow_taxi_data
WHERE
  "DOLocationID" NOT IN (
    SELECT
      "LocationID"
    FROM
      zones
  )
  OR "PULocationID" NOT IN (
    SELECT
      "LocationID"
    FROM
      zones
  )
LIMIT
  100;

/* Using LEFT, RIGHT, and OUTER JOINS when some Location IDs are not in either Tables Borough*/
DELETE FROM
  zones
WHERE
  "LocationID" = 142;

SELECT
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  total_amount,
  CONCAT(zpu."Borough", ' | ', zpu."Zone") AS "pickup_loc",
  CONCAT(zdo."Borough", ' | ', zdo."Zone") AS "dropoff_loc"
FROM
  yellow_taxi_data t
  LEFT JOIN zones zpu ON t."PULocationID" = zpu."LocationID"
  JOIN zones zdo ON t."DOLocationID" = zdo."LocationID"
LIMIT
  100;

SELECT
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  total_amount,
  CONCAT(zpu."Borough", ' | ', zpu."Zone") AS "pickup_loc",
  CONCAT(zdo."Borough", ' | ', zdo."Zone") AS "dropoff_loc"
FROM
  yellow_taxi_data t
  RIGHT JOIN zones zpu ON t."PULocationID" = zpu."LocationID"
  JOIN zones zdo ON t."DOLocationID" = zdo."LocationID"
LIMIT
  100;

/* Using GROUP BY to calculate number of trips per day */
SELECT
  CAST(tpep_dropoff_datetime AS DATE) AS "day",
  COUNT(1)
FROM
  yellow_taxi_data
GROUP BY
  CAST(tpep_dropoff_datetime AS DATE)
LIMIT
  100;

/* Using ORDER BY to order the results of your query */

-- Ordering by day

SELECT
    CAST(tpep_dropoff_datetime AS DATE) AS "day",
    COUNT(1)
FROM 
    yellow_taxi_data
GROUP BY
    CAST(tpep_dropoff_datetime AS DATE)
ORDER BY
    "day" ASC
LIMIT 100;

-- Ordering by count

SELECT
    CAST(tpep_dropoff_datetime AS DATE) AS "day",
    COUNT(1) AS "count"
FROM 
    yellow_taxi_data
GROUP BY
    CAST(tpep_dropoff_datetime AS DATE)
ORDER BY
    "count" DESC
LIMIT 100;

/* Grouping by multiple fields */

SELECT
    CAST(tpep_dropoff_datetime AS DATE) AS "day",
    "DOLocationID",
    COUNT(1) AS "count",
    MAX(total_amount) AS "total_amount",
    MAX(passenger_count) AS "passenger_count"
FROM 
    yellow_taxi_data
GROUP BY
    1, 2
ORDER BY
    "day" ASC, 
    "DOLocationID" ASC
LIMIT 100;