
  create or replace   view ev_infra_analysis.analytics.dim_times
  
  
  
  
  as (
    

WITH dates AS (
  SELECT DISTINCT registration_date AS date_key
  FROM ev_infra_analysis.staging.stg_vehicles
  UNION
  SELECT DISTINCT date_first_operational
  FROM ev_infra_analysis.staging.stg_charging_stations
)
SELECT
  date_key,
  YEAR(date_key) AS year,
  MONTH(date_key) AS month
FROM dates
WHERE date_key IS NOT NULL
  );

