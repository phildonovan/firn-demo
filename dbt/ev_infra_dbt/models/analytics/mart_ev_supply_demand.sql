{{ config(materialized='view') }}

SELECT
  dd.year,
  dd.month,
  dd.month_name,
  COALESCE(fm.monthly_ev_count, 0) AS monthly_ev_count,
  COALESCE(fm.cumulative_ev_count, 0) AS cumulative_ev_count,
  COALESCE(fm.monthly_station_count, 0) AS monthly_station_count,
  COALESCE(fm.cumulative_station_count, 0) AS cumulative_station_count,
  COALESCE(fm.monthly_connector_sum, 0) AS monthly_connector_sum,
  COALESCE(fm.cumulative_connector_sum, 0) AS cumulative_connector_sum,
  COALESCE(fm.cumulative_ev_count / NULLIF(fm.cumulative_station_count, 0), 0) AS cumulative_ev_per_station_ratio,
  COALESCE(fm.cumulative_ev_count / NULLIF(fm.cumulative_connector_sum, 0), 0) AS cumulative_ev_per_connector_ratio
FROM {{ ref('dim_year_month_span') }} dd
LEFT JOIN {{ ref('fact_ev_charging_metrics') }} fm ON dd.date_key = fm.date_key
WHERE dd.year IS NOT NULL
