#!/bin/bash

# Variables (customize as needed)
DB_NAME="ipl"              # Database name
DB_USER="postgres"         # PostgreSQL admin username
POSTGRES_PASSWORD="4123"   # PostgreSQL admin password
POSTGRES_HOST="localhost"  # Change if not localhost
POSTGRES_PORT="5432"       # Change if your PostgreSQL runs on a different port
CSV_FILE_PATH="/mnt/c/Users/raiva/OneDrive/Desktop/archive/matches.csv" # Path to your CSV file
TABLE_NAME="matches"       # Name of the table where data will be loaded

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
        id SERIAL PRIMARY KEY,
        season INTEGER,
        city TEXT,
        date DATE,
        team1 TEXT,
        team2 TEXT,
        toss_winner TEXT,
        toss_decision TEXT,
        result TEXT,
        dl_applied INTEGER,
        winner TEXT,
        win_by_runs INTEGER,
        win_by_wickets INTEGER,
        player_of_match TEXT,
        venue TEXT,
        umpire1 TEXT,
        umpire2 TEXT,
        umpire3 TEXT
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
    COPY $TABLE_NAME (id, season, city, date, team1, team2, toss_winner, toss_decision, result, dl_applied, winner, win_by_runs, win_by_wickets, player_of_match, venue, umpire1, umpire2, umpire3)
    FROM '$CSV_FILE_PATH' DELIMITER ',' CSV HEADER;
EOSQL

if [ $? -eq 0 ]; then
    echo "CSV data loaded into table '$TABLE_NAME' successfully."
else
    echo "An error occurred while loading the data."
fi

# Unset password variable for security
unset PGPASSWORD
