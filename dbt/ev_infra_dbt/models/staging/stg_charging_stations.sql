{{ config(materialized='table') }}

SELECT
  data:"ADDRESS"::VARCHAR AS address,
  REGEXP_REPLACE(data:"GlobalID"::VARCHAR, '^\\{|\\}$', '') AS global_id,  -- Removes { and }
  data:"NAME"::VARCHAR AS name,
  data:"OBJECTID"::VARCHAR AS objectid,
  data:"OPERATOR"::VARCHAR AS operator,
  data:"OWNER"::VARCHAR AS owner,
  data:"Type"::VARCHAR AS type,
  data:"carParkCount"::INT AS car_park_count,
  data:"connectorsList"::VARCHAR AS connectors_list,
  data:"currentType"::VARCHAR AS current_type,
  TRY_TO_DATE(data:"dateFirstOperational"::VARCHAR, 'DD/MM/YYYY') AS date_first_operational,
  data:"hasCarparkCost"::BOOLEAN AS has_carpark_cost,
  data:"hasChargingCost"::BOOLEAN AS has_charging_cost,
  data:"hasTouristAttraction"::BOOLEAN AS has_tourist_attraction,
  data:"is24Hours"::BOOLEAN AS is_24_hours,
  data:"latitude"::FLOAT AS latitude,
  data:"longitude"::FLOAT AS longitude,
  data:"maxTimeLimit"::VARCHAR AS max_time_limit,
  data:"numberOfConnectors"::INT AS number_of_connectors,
  TO_GEOGRAPHY('POINT(' || data:"longitude"::FLOAT || ' ' || data:"latitude"::FLOAT || ')') AS geometry  -- Casts to GEOGRAPHY point
FROM {{ source('raw', 'raw_charging_stations') }}
