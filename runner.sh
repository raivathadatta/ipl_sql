#!/bin/bash

DB_NAME="ipl"                  # Database name
DB_USER="postgres"             # PostgreSQL username
DB_HOST="localhost"            # PostgreSQL host
DB_PORT="5432"                 # PostgreSQL port
PASSWORD="4123"                # PostgreSQL password
SQL_DIR="./ipl_sql"            # Directory containing SQL files
LOG_FILE="./query_log.txt"     # Log file to capture output

export PGPASSWORD=$PASSWORD

if [ ! -d "$SQL_DIR" ]; then
  echo "Directory $SQL_DIR does not exist."
  exit 1
fi

echo "Starting execution of SQL files in $SQL_DIR..."

for sql_file in "$SQL_DIR"/*.sql; do
  echo "Executing $sql_file..."
  psql -h $DB_HOST -U $DB_USER -d $DB_NAME -p $DB_PORT -f "$sql_file" >> "$LOG_FILE" 2>&1
  if [ $? -eq 0 ]; then
    echo "$sql_file executed successfully."
  else
    echo "Error occurred while executing $sql_file. Check $LOG_FILE for details."
    exit 1
  fi
done

unset PGPASSWORD

echo "All SQL files executed successfully. Check $LOG_FILE for details."
