#!/bin/bash

# Variables (customize as needed)
DB_USER="raiivatha"        # Replace with the desired new username
DB_PASSWORD="4123" # Replace with the new user's password
DB_NAME="ipl"    # Replace with the desired database name
POSTGRES_USER="postgres"  # Your PostgreSQL admin username
POSTGRES_PASSWORD="4123"  # Your PostgreSQL admin password
POSTGRES_HOST="localhost" # Change if not localhost
POSTGRES_PORT="5432"      # Change if your PostgreSQL runs on a different port

# Export admin credentials
export PGPASSWORD=$POSTGRES_PASSWORD

echo "Creating PostgreSQL user and database..."

# Execute PostgreSQL commands
psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -v ON_ERROR_STOP=1 <<-EOSQL
    CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
    CREATE DATABASE $DB_NAME;
    ALTER DATABASE $DB_NAME OWNER TO $DB_USER;
EOSQL

if [ $? -eq 0 ]; then
    echo "User '$DB_USER' and database '$DB_NAME' created successfully."
else
    echo "An error occurred during the creation process."
fi

# Unset password variable for security
unset PGPASSWORD
