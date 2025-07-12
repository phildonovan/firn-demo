{{ config(materialized='view') }}

SELECT
  registration_date AS time_key,
  tla AS location_key,
  COUNT(*) AS ev_count,
  AVG(power_rating) AS avg_power_rating
FROM {{ ref('stg_vehicles') }}
GROUP BY registration_date, tla
