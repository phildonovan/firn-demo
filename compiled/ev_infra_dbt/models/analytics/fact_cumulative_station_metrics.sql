

WITH station_metrics AS (
  SELECT
    DATE_TRUNC('MONTH', date_first_operational) AS time_key,
    COUNT(*) AS station_count,
    SUM(number_of_connectors) AS connector_sum
  FROM ev_infra_analysis.staging.stg_charging_stations
  GROUP BY time_key
)
SELECT
  dd.date_key,
  dd.year,
  dd.month_name,
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
FROM ev_infra_analysis.analytics.dim_year_month_span dd
LEFT JOIN station_metrics sm
  ON dd.date_key = sm.time_key
WHERE dd.year IS NOT NULL