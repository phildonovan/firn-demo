# Electric Vehicle Infrastructure Analytics Case Study

This project is a case study analyzing vehicle registration data and electric vehicle (EV) charging station data in New Zealand using dbt, Snowflake, and Streamlit. The goal is to process raw data, transform it into a usable format, and present insights through an interactive Streamlit application.

## Project Overview

The project involves:
- Deploying a Snowflake database (`EV_INFRA_ANALYTICS`) using the Snowflake CLI.
- Loading raw vehicle registration and charging station data into Snowflake.
- Transforming the data using dbt to create staging and analytics models.
- Visualizing the results through a Streamlit app hosted in Snowflake.

## Repository Structure

- **snowflake-commands/**: Contains scripts and commands for Snowflake CLI operations, including database deployment, data staging, and data extraction.
- **dbt/**: Contains dbt models for data transformation (staging and analytics).
- **streamlit/**: Contains the Streamlit app for data analysis and visualization.

## Setup and Deployment

### 1. Snowflake Database Setup
The Snowflake database (`EV_INFRA_ANALYTICS`) is created and managed using the Snowflake CLI (`snow`). The database includes the following schemas:
- **raw**: Stores raw data files and tables.
- **staging**: Contains transformed tables for intermediate processing.
- **analytics**: Contains fact, dimension, and mart views for analysis.

#### Steps:
1. **Database and Schema Creation**:
   - The database and schemas (`raw`, `staging`, `analytics`) are created using Snowflake CLI commands.
   - A stage (`raw_stage`) is created in the `raw` schema to hold uploaded data files.

2. **Data Loading**:
   - Data files (vehicle registration and charging station data) are uploaded to the `raw_stage` using the `snow sql -q "PUT file://<path-to-data> @raw_stage"` command.
   - SQL scripts extract data from the stage into tables in the `raw` schema.

3. **Automation**:
   - A Linux shell script (`snowflake-commands/deploy.sh`) automates the following:
     - Database and schema creation.
     - Data upload to the `raw_stage`.
     - Data extraction from the stage to tables in the `raw` schema.
   - Run the script: `bash snowflake-commands/deploy.sh`.

### 2. Data Transformation with dbt
The dbt project transforms raw data into analytics-ready models.

#### Staging Models
- Located in `dbt/models/staging/`.
- Transform raw data into a more usable format.
- Example: Unnest JSON data from the charging station dataset into structured tables.

#### Analytics Models
- Located in `dbt/models/analytics/`.
- Create fact, dimension, and mart views:
  - **Fact Tables**: Aggregated metrics (e.g., number of registered vehicles or charging sessions).
  - **Dimension Tables**: Descriptive attributes (e.g., vehicle types, charging station locations).
  - **Mart Views**: Analyst-friendly views combining fact and dimension tables for reporting.
- Run dbt: `dbt run` to execute the transformations.

### 3. Streamlit Application
- A Streamlit app is deployed in Snowflake to analyze and visualize the transformed data.
- The app queries the mart views in the `analytics` schema to present insights interactively.
- Access the app via Snowflake’s UI or a provided URL after deployment.

## Prerequisites
- **Snowflake Account**: Configured with appropriate permissions.
- **Snowflake CLI**: Installed and configured with credentials.
- **dbt**: Installed and configured to connect to the Snowflake database.
- **Streamlit**: Configured in Snowflake for app deployment.
- **Linux Environment**: For running the shell script (optional if running commands manually).

## Usage
1. **Deploy the Database**:
   - Navigate to `snowflake-commands/`.
   - Run `bash deploy.sh` to set up the database, upload data, and extract it to the `raw` schema.

2. **Run dbt Transformations**:
   - Navigate to the `dbt/` directory.
   - Run `dbt run` to create staging and analytics models.

3. **Launch the Streamlit App**:
   - Deploy the Streamlit app in Snowflake.
   - Access the app through Snowflake to explore the data.

## Notes
- Ensure the Snowflake CLI configuration file (`config.toml`) is set up with the correct credentials and warehouse details.
- The vehicle charging data in JSON format requires careful unnesting in the staging models to ensure data integrity.
- The Streamlit app is designed to work with the mart views in the `analytics` schema for optimal performance.

## Future Improvements
- Add automated tests in dbt to validate data quality.
- Enhance the Streamlit app with additional visualizations and filters.
- Optimize Snowflake queries for faster performance on large datasets.