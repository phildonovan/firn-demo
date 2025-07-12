#!/bin/bash
# Script to load data using SnowCLI
# Usage: ./build-ev-db.sh [electric-vehicles-raw]
# Prerequisites: 
# - SnowCLI installed and connection configured.
# - Set DATA_DIR env var if not using default (e.g., export DATA_DIR=/home/phildonovan/projects/firn-data-project/data)
# - Data files in DATA_DIR: motor-vehicle-register-api-dt.csv and ev-roam-charging-stations-data.json
# - load_vehicles.sql and load_charging_stations.sql in the same folder, configured for .gz CSV.

CONNECTION=${1:-electric-vehicles-raw}
DATA_DIR=${DATA_DIR:-./../data} 

echo "Uploading data... Electric Vehicles CSV"
snow sql -q "PUT file://$DATA_DIR/motor-vehicle-register-api-dt.csv @EV_INFRA_ANALYSIS.RAW.raw_stage AUTO_COMPRESS=TRUE;" --connection "$CONNECTION" || { echo "CSV upload failed"; exit 1; }

echo "Uploading data... Charging Stations JSON"
snow sql -q "PUT file://$DATA_DIR/ev-roam-charging-stations-data.json @EV_INFRA_ANALYSIS.RAW.raw_stage AUTO_COMPRESS=FALSE;" --connection "$CONNECTION" || { echo "JSON upload failed"; exit 1; }

echo "Loading vehicles (gzipped CSV)..."
snow sql -f sql/load-vehicles.sql --connection "$CONNECTION" || { echo "Vehicles load failed"; exit 1; }

echo "Loading charging stations..."
snow sql -f sql/load-charging-stations.sql --connection "$CONNECTION" || { echo "Stations load failed"; exit 1; }

echo "Load complete. Verify with: snow sql -q 'SELECT COUNT(*) FROM raw.vehicles;' --connection \"$CONNECTION\""
