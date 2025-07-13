-- The purpose of this script is to deploy the datebase according to what I need.

-- Deploy database
CREATE DATABASE IF NOT EXISTS ev_infra_analytics;

-- Build schemas
DROP SCHEMA IF EXISTS ev_infra_analytics.public;
CREATE SCHEMA IF NOT EXISTS ev_infra_analytics.raw;
CREATE SCHEMA IF NOT EXISTS ev_infra_analytics.staging;
CREATE SCHEMA IF NOT EXISTS ev_infra_analytics.analytics;

-- Create a Snowflake stage, for placing the data into, for then uploading into the raw schema.
CREATE STAGE IF NOT EXISTS ev_infra_analytics.raw.raw_stage;
