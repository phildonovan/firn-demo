{{ config(materialized='view') }}

SELECT
  tla,
  COUNT(*) AS total_ev_count
FROM {{ ref('stg_vehicles') }}
WHERE is_electric = TRUE
GROUP BY tla
HAVING total_ev_count > 0
ORDER BY total_ev_count DESC
