

WITH station_counts AS (
  SELECT
    DATE_TRUNC('MONTH', date_first_operational) AS time_key,
    COUNT(*) AS station_count
  FROM ev_infra_analysis.staging.stg_charging_stations
  GROUP BY time_key
)
SELECT
  dd.date_key,
  dd.year,
  dd.month_name,
  COALESCE(sc.station_count, 0) AS monthly_station_count,
  SUM(COALESCE(sc.station_count, 0)) OVER (
    ORDER BY dd.date_key
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS cumulative_station_count
FROM ev_infra_analysis.analytics.dim_year_month_span dd
LEFT JOIN station_counts sc
  ON dd.date_key = sc.time_key
WHERE dd.year IS NOT NULL