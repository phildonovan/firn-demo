

SELECT DISTINCT tla AS location_key
FROM ev_infra_analysis.staging.stg_vehicles
WHERE tla IS NOT NULL
UNION
SELECT DISTINCT REGEXP_REPLACE(address, '.*, (.*)$', '\\1') AS location_key
FROM ev_infra_analysis.staging.stg_charging_stations
WHERE address IS NOT NULL