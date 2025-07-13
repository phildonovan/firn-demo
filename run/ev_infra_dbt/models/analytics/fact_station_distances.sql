
  create or replace   view ev_infra_analysis.analytics.fact_station_distances
  
  
  
  
  as (
    



SELECT
  s1.objectid AS station1_id,
  s1.name AS station1_name,
  s1.latitude AS station1_lat,
  s1.longitude AS station1_lon,
  s1.geometry AS station1_geometry,  -- GEOGRAPHY
  s2.objectid AS station2_id,
  s2.name AS station2_name,
  s2.latitude AS station2_lat,
  s2.longitude AS station2_lon,
  s2.geometry AS station2_geometry,  -- GEOGRAPHY
  HAVERSINE(s1.latitude, s1.longitude, s2.latitude, s2.longitude) AS distance_km_haversine,
  ST_DISTANCE(s1.geometry, s2.geometry) / 1000 AS distance_km_st_distance  -- Convert meters to km
FROM ev_infra_analysis.staging.stg_charging_stations s1
LEFT JOIN ev_infra_analysis.staging.stg_charging_stations s2
  ON s1.objectid != s2.objectid  -- Avoid self-pairing
WHERE distance_km_haversine IS NOT NULL
  AND distance_km_st_distance IS NOT NULL
ORDER BY station1_id, distance_km_haversine
  );

