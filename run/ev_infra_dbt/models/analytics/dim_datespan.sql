
  create or replace   view ev_infra_analysis.analytics.dim_datespan
  
  
  
  
  as (
    WITH date_bounds AS (
  SELECT
    MIN(registration_date) AS min_date,
    MAX(registration_date) AS max_date
  FROM ev_infra_analysis.staging.stg_vehicles
  UNION ALL
  SELECT
    MIN(date_first_operational),
    MAX(date_first_operational)
  FROM ev_infra_analysis.staging.stg_charging_stations
),
min_max_date AS (
  SELECT
    MIN(min_date) AS min_date,
    MAX(max_date) AS max_date
  FROM date_bounds
),
monthly_range AS (
  SELECT
    DATE_TRUNC('MONTH', TO_DATE(date)) AS date_key
  FROM min_max_date,
  LATERAL FLATTEN(input => GENERATE_DATE_ARRAY(min_date, max_date, INTERVAL '1 MONTH'))
)
SELECT
  date_key,
  YEAR(date_key) AS year,
  MONTH(date_key) AS month,
  MONTHNAME(date_key) AS month_name,
  MONTHNAME(date_key, 'short') AS month_short_name
FROM monthly_range
WHERE date_key IS NOT NULL
ORDER BY date_key
  );

