{{ config(materialized='view') }}

WITH ranked_distances AS (
  SELECT
    station1_id,
    station1_name,
    station2_id,
    station2_name,
    distance_km_st_distance,
    station1_lat,
    station2_lon,
    station1_geometry,
    ROW_NUMBER() OVER (
      PARTITION BY station1_id
      ORDER BY distance_km_st_distance ASC
    ) AS rank
  FROM {{ ref('fact_station_distances') }}
  WHERE distance_km_st_distance IS NOT NULL
    AND distance_km_st_distance > 0  -- Exclude self (distance 0 if any)
),
top_5_distances AS (
  SELECT
    station1_id,
    station1_name,
    ANY_VALUE(station1_lat) AS lat,
    ANY_VALUE(station2_lon) AS lon,
    AVG(distance_km_st_distance) AS avg_closest_5_distance_km,
    ANY_VALUE(station1_geometry) AS station_geometry  -- Aggregate geometry (since same for all rows per station1_id)
  FROM ranked_distances
  WHERE rank <= 5
  GROUP BY station1_id, station1_name
)
SELECT
  station1_id AS station_id,
  station1_name AS station_name,
  avg_closest_5_distance_km,
  lat,
  lon,
  station_geometry
FROM top_5_distances
ORDER BY avg_closest_5_distance_km DESC
