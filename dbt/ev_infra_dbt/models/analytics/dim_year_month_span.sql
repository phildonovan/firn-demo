{{ config(materialized='view') }}

WITH date_bounds AS (
  SELECT
    MIN(registration_date) AS min_date,
    MAX(registration_date) AS max_date
  FROM {{ ref('stg_vehicles') }}
  UNION ALL
  SELECT
    MIN(date_first_operational),
    MAX(date_first_operational)
  FROM {{ ref('stg_charging_stations') }}
),
min_max_date AS (
  SELECT
    MIN(min_date) AS min_date,
    MAX(max_date) AS max_date
  FROM date_bounds
),
monthly_range AS (
  SELECT
    DATE_TRUNC('MONTH', min_date) AS date_key
  FROM min_max_date
  UNION ALL
  SELECT
    DATEADD(MONTH, 1, date_key)
  FROM monthly_range
  WHERE date_key < (SELECT DATE_TRUNC('MONTH', max_date) FROM min_max_date)
)
SELECT
  date_key,
  YEAR(date_key) AS year,
  MONTH(date_key) AS month,
  MONTHNAME(date_key) AS month_name
FROM monthly_range
WHERE date_key IS NOT NULL
ORDER BY date_key
