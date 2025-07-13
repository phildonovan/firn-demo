
  create or replace   view ev_infra_analysis.analytics.mart_charging_station
  
  
  
  
  as (
    

SELECT
  s.objectid,
  s.name,
  s.address,
  s.latitude,
  s.longitude,
  s.geometry,  -- GEOGRAPHY point
  s.number_of_connectors,
  ST_BUFFER(s.geometry, 5000) AS catchment_geometry  -- 5km radius in meters
FROM ev_infra_analysis.staging.stg_charging_stations s
  );

