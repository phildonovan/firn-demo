
  create or replace   view ev_infra_analysis.analytics.mart_ev_tla
  
  
  
  
  as (
    

SELECT
  tla,
  COUNT(*) AS total_ev_count
FROM ev_infra_analysis.staging.stg_vehicles
WHERE is_electric = TRUE
GROUP BY tla
HAVING total_ev_count > 0
ORDER BY total_ev_count DESC
  );

