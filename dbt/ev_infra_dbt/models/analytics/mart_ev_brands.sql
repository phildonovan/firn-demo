{{ config(materialized='view') }}

WITH brand_counts AS (
  SELECT
    DATE_TRUNC('MONTH', registration_date) AS time_key,
    make,
    COUNT(*) AS ev_count
  FROM {{ ref('stg_vehicles') }}
  WHERE is_electric = TRUE
  GROUP BY time_key, make
),
all_brands AS (
  SELECT DISTINCT make
  FROM {{ ref('stg_vehicles') }}
  WHERE is_electric = TRUE
)
SELECT
  dd.date_key,
  dd.year,
  dd.month,
  dd.month_name,
  ab.make,
  COALESCE(bc.ev_count, 0) AS monthly_ev_count,
  SUM(COALESCE(bc.ev_count, 0)) OVER (
    PARTITION BY ab.make
    ORDER BY dd.date_key
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS cumulative_ev_count
FROM {{ ref('dim_year_month_span') }} dd
CROSS JOIN all_brands ab
LEFT JOIN brand_counts bc
  ON dd.date_key = bc.time_key AND ab.make = bc.make
WHERE dd.date_key IS NOT NULL
ORDER BY dd.year, dd.month, ab.make
