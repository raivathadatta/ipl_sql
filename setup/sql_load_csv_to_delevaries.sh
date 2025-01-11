#!/bin/bash

# Variables (customize as needed)
DB_NAME="ipl"              # Database name
DB_USER="postgres"         # PostgreSQL admin username
POSTGRES_PASSWORD="4123"   # PostgreSQL admin password
POSTGRES_HOST="localhost"  # Change if not localhost
POSTGRES_PORT="5432"       # Change if your PostgreSQL runs on a different port
CSV_FILE_PATH="/mnt/c/Users/raiva/OneDrive/Desktop/archive/deliveries.csv" # Path to your CSV file
TABLE_NAME="deliveries"    # Name of the table where data will be loaded

# Export admin credentials
export PGPASSWORD=$POSTGRES_PASSWORD

# Create the database if it doesn't exist
echo "Creating database '$DB_NAME' if it doesn't exist..."
psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $DB_USER -v ON_ERROR_STOP=1 <<-EOSQL
    CREATE DATABASE $DB_NAME;
EOSQL

if [ $? -eq 0 ]; then
    echo "Database '$DB_NAME' created or already exists."
else
    echo "An error occurred while creating the database."
fi

# Create the table if it doesn't exist
echo "Creating table '$TABLE_NAME' if it doesn't exist..."
psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $DB_USER -d $DB_NAME -v ON_ERROR_STOP=1 <<-EOSQL
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
        match_id INTEGER,
        inning INTEGER,
        batting_team TEXT,
        bowling_team TEXT,
        over INTEGER,
        ball INTEGER,
        batsman TEXT,
        non_striker TEXT,
        bowler TEXT,
        is_super_over INTEGER,
        wide_runs INTEGER,
        bye_runs INTEGER,
        legbye_runs INTEGER,
        noball_runs INTEGER,
        penalty_runs INTEGER,
        batsman_runs INTEGER,
        extra_runs INTEGER,
        total_runs INTEGER,
        player_dismissed TEXT,
        dismissal_kind TEXT,
        fielder TEXT
    );
EOSQL

if [ $? -eq 0 ]; then
    echo "Table '$TABLE_NAME' created or already exists."
else
    echo "An error occurred while creating the table."
    exit 1
fi

# Load the data into the table
echo "Loading CSV data into PostgreSQL table..."
psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $DB_USER -d $DB_NAME -v ON_ERROR_STOP=1 <<-EOSQL
    COPY $TABLE_NAME (match_id, inning, batting_team, bowling_team, over, ball, batsman, non_striker, bowler, is_super_over, wide_runs, bye_runs, legbye_runs, noball_runs, penalty_runs, batsman_runs, extra_runs, total_runs, player_dismissed, dismissal_kind, fielder)
    FROM '$CSV_FILE_PATH' DELIMITER ',' CSV HEADER;
EOSQL

if [ $? -eq 0 ]; then
    echo "CSV data loaded into table '$TABLE_NAME' successfully."
else
    echo "An error occurred while loading the data."
fi

# Unset password variable for security
unset PGPASSWORD
