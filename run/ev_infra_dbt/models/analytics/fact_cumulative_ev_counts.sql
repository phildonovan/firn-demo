
  create or replace   view ev_infra_analysis.analytics.fact_cumulative_ev_counts
  
  
  
  
  as (
    

WITH ev_counts AS (
  SELECT
    DATE_TRUNC('MONTH', registration_date) AS time_key,
    tla,
    COUNT(*) AS ev_count
  FROM ev_infra_analysis.staging.stg_vehicles
  GROUP BY time_key, tla
)
SELECT
  dd.date_key,
  dd.year,
  dd.month_name,
  ec.tla,
  COALESCE(ec.ev_count, 0) AS monthly_ev_count,
  SUM(COALESCE(ec.ev_count, 0)) OVER (
    PARTITION BY ec.tla
    ORDER BY dd.date_key
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS cumulative_ev_count
FROM ev_infra_analysis.analytics.dim_year_month_span dd
LEFT JOIN ev_counts ec
  ON dd.date_key = ec.time_key
WHERE dd.year IS NOT NULL
  );

