{{ config(materialized='view') }}

WITH dates AS (
  SELECT DISTINCT registration_date AS date_key
  FROM {{ ref('stg_vehicles') }}
  UNION
  SELECT DISTINCT date_first_operational
  FROM {{ ref('stg_charging_stations') }}
)
SELECT
  date_key,
  YEAR(date_key) AS year,
  MONTH(date_key) AS month,
  MONTHNAME(date_key) AS short_month_name,  
  TO_CHAR(TO_DATE(date_key), 'MMMM') AS full_month_name,
  DAY(date_key) AS day_of_month,
  DAYNAME(date_key) AS day_name
FROM dates
WHERE date_key IS NOT NULL
