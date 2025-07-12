{{ config(materialized='view') }}

WITH ev_counts AS (
  SELECT
    DATE_TRUNC('MONTH', registration_date) AS time_key,
    COUNT(*) AS ev_count
  FROM {{ ref('stg_vehicles') }}
  GROUP BY time_key
),
station_metrics AS (
  SELECT
    DATE_TRUNC('MONTH', date_first_operational) AS time_key,
    COUNT(*) AS station_count,
    SUM(number_of_connectors) AS connector_sum
  FROM {{ ref('stg_charging_stations') }}
  GROUP BY time_key
)
SELECT
  dd.date_key,
  dd.year,
  dd.month,
  dd.month_name,
  COALESCE(ec.ev_count, 0) AS monthly_ev_count,
  SUM(COALESCE(ec.ev_count, 0)) OVER (
    ORDER BY dd.date_key
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS cumulative_ev_count,
  COALESCE(sm.station_count, 0) AS monthly_station_count,
  SUM(COALESCE(sm.station_count, 0)) OVER (
    ORDER BY dd.date_key
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS cumulative_station_count,
  COALESCE(sm.connector_sum, 0) AS monthly_connector_sum,
  SUM(COALESCE(sm.connector_sum, 0)) OVER (
    ORDER BY dd.date_key
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS cumulative_connector_sum
FROM {{ ref('dim_year_month_span') }} dd
LEFT JOIN ev_counts ec ON dd.date_key = ec.time_key
LEFT JOIN station_metrics sm ON dd.date_key = sm.time_key
WHERE dd.year IS NOT NULL
