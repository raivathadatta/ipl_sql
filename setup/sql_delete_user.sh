#!/bin/bash

# Variables (customize as needed)
DB_USER="raiivatha"        # The username to be deleted
DB_NAME="ipl"              # The database to be deleted
POSTGRES_USER="postgres"   # Your PostgreSQL admin username
POSTGRES_PASSWORD="4123"   # Your PostgreSQL admin password
POSTGRES_HOST="localhost"  # Change if not localhost
POSTGRES_PORT="5432"       # Change if your PostgreSQL runs on a different port

# Export admin credentials
export PGPASSWORD=$POSTGRES_PASSWORD

echo "Cleaning up PostgreSQL user and database..."

# Execute PostgreSQL commands
psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -v ON_ERROR_STOP=1 <<-EOSQL
    DROP DATABASE IF EXISTS $DB_NAME;
    DROP USER IF EXISTS $DB_USER;
EOSQL

if [ $? -eq 0 ]; then
    echo "User '$DB_USER' and database '$DB_NAME' have been deleted successfully."
else
    echo "An error occurred during the cleanup process."
fi

# Unset password variable for security
unset PGPASSWORD
