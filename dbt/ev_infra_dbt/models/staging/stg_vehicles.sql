{{ config(materialized='table') }}

SELECT
  objectid,
  make,
  model,
  motive_power,
  tla,
  TO_DATE(first_nz_registration_year || '-' || first_nz_registration_month || '-01', 'YYYY-MM-DD') AS registration_date,
  vehicle_year,
  gross_vehicle_mass,  
  power_rating,       
  fc_combined AS fuel_consumption_combined,  
  COALESCE(submodel, 'UNKNOWN') AS submodel,
  CASE 
    WHEN motive_power ILIKE '%ELECTRIC%' OR motive_power ILIKE '%PLUG-IN%' THEN TRUE 
    ELSE FALSE 
  END AS is_electric
FROM {{ source('raw', 'raw_vehicles') }}  -- Adjusted to match your source name
WHERE is_electric = TRUE
