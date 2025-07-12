-- Load motor vehicle register CSV from stage into raw.vehicles table
-- Loads the motor-vehicle-register-api-dt.csv.gz table in the stage @raw_stage to the raw schema as a table.

USE SCHEMA raw;

CREATE TABLE IF NOT EXISTS vehicles (
  objectid INT,
  alternative_motive_power VARCHAR,
  basic_colour VARCHAR,
  body_type VARCHAR,
  cc_rating INT,
  chassis7 VARCHAR,
  class VARCHAR,
  engine_number VARCHAR,
  first_nz_registration_year INT,
  first_nz_registration_month INT,
  gross_vehicle_mass INT,
  height INT,
  import_status VARCHAR,
  industry_class VARCHAR,
  industry_model_code VARCHAR,
  make VARCHAR,
  model VARCHAR,
  motive_power VARCHAR,
  mvma_model_code VARCHAR,
  number_of_axles INT,
  number_of_seats INT,
  nz_assembled VARCHAR,
  original_country VARCHAR,
  power_rating INT,
  previous_country VARCHAR,
  road_transport_code VARCHAR,
  submodel VARCHAR,
  tla VARCHAR,
  transmission_type VARCHAR,
  vdam_weight INT,
  vehicle_type VARCHAR,
  vehicle_usage VARCHAR,
  vehicle_year INT,
  vin11 VARCHAR,
  width INT,
  synthetic_greenhouse_gas VARCHAR,
  fc_combined FLOAT,
  fc_urban FLOAT,
  fc_extra_urban FLOAT
);

COPY INTO vehicles
FROM @raw_stage/motor-vehicle-register-api-dt.csv.gz
FILE_FORMAT = (TYPE = 'CSV', COMPRESSION = 'GZIP', SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY = '\"', ESCAPE_UNENCLOSED_FIELD = 'NONE');
