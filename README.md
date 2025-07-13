# Electric Vehicle Infrastructure Analytics Case Study

This project is a case study analyzing vehicle registration data and electric vehicle (EV) charging station data in New Zealand using dbt, Snowflake, and Streamlit. The goal is to process raw data, transform it into a usable format, and present insights through an interactive Streamlit application. All development and execution occur within a `uv` virtual environment for dependency management.

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

### 1. Virtual Environment Setup
This project uses a `uv` virtual environment to manage Python dependencies.
- **Install uv**: Follow the instructions at [uv documentation](https://docs.astral.sh/uv/) to install `uv`.
- **Create and Activate Virtual Environment**:
  ```bash
  uv venv
  source .venv/bin/activate
  ```
- **Install Dependencies**:
  ```bash
  uv pip install -r requirements.txt
  ```
  Ensure `requirements.txt` includes dependencies like `dbt-snowflake`, `snowflake-cli`, and `streamlit`.

### 2. Snowflake Database Setup
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
   - SQL scripts extract data from the stage into