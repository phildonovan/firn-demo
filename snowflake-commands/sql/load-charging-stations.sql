-- Load EV charging stations JSON from stage into raw.charging_stations_raw table

USE SCHEMA raw;

CREATE TABLE IF NOT EXISTS charging_stations_raw (data VARIANT);

COPY INTO charging_stations_raw
FROM @raw_stage/ev-roam-charging-stations-data.json
FILE_FORMAT = (TYPE = 'JSON', STRIP_OUTER_ARRAY = TRUE);
