# Instructions for Running SQL Queries with `.sh` Files

This document provides instructions for running SQL queries using two `.sh` files: **file_runner.sh** and **folder_runner.sh**. Both scripts are used to run SQL queries, but they operate differently and are designed for different use cases.

## 1. file_runner.sh

### Steps to Use file_runner.sh:

1. **Move the File**:
    - Move the `file_runner.sh` to a different folder where your SQL files and relevant data are stored.
    
2. **Replace the Variables**:
    - Open `file_runner.sh` and replace the placeholder variables (such as `DB_NAME`, `DB_USER`, `DB_PASSWORD`, etc.) with your actual values:
      - `DB_NAME` -> Your PostgreSQL database name.
      - `DB_USER` -> Your PostgreSQL username.
      - `DB_PASSWORD` -> Your PostgreSQL password.
      - This allows the script to connect to your database using the credentials you provide.

3. **Run the Script**:
    - Open the terminal in the folder where `file_runner.sh` is located.
    - Ensure the file has execute permissions. If not, use:
      ```bash
      chmod +x file_runner.sh
      ```
    - Now, run the script using the following command:
      ```bash
      ./file_runner.sh
      ```
    - Alternatively, you can use:
      ```bash
      bash file_runner.sh
      ```

4. **Logger File**:
    - After successful execution, a `logger.txt` file will be created. This file will contain the responses from the SQL queries executed by the script. 
    - The logger will show if the queries executed successfully or failed, along with any output from the SQL queries.

---

## 2. folder_runner.sh

### Steps to Use folder_runner.sh:

1. **Move the Folder**:
    - Move the folder containing the SQL files just above the `sql_ipl` folder.
    - This folder should contain all the SQL files that you want to run.

2. **Replace Variables**:
    - Open `folder_runner.sh` and replace the following placeholders:
      - `DB_NAME` -> Your PostgreSQL database name.
      - `DB_USER` -> Your PostgreSQL username.
      - `DB_PASSWORD` -> Your PostgreSQL password.

3. **Run the Script**:
    - Open the terminal in the folder where `folder_runner.sh` is located.
    - Ensure the script has execute permissions. If not, use:
      ```bash
      chmod +x folder_runner.sh
      ```
    - Run the script using the following command:
      ```bash
      ./folder_runner.sh
      ```
    - Alternatively, you can use:
      ```bash
      bash folder_runner.sh
      ```

4. **Logging the Responses**:
    - In **folder_runner.sh**, all the responses from the SQL queries will be placed in a log file, one after the other, corresponding to each SQL query.
    - The execution will happen in the order the files are listed in the folder. This means that if there are multiple SQL files in the folder, the queries will be executed in sequence.

---

## 3. How the Scripts Work

### file_runner.sh

- **Purpose**: The script is designed to run SQL queries from a single `.sh` file. It connects to the PostgreSQL database and runs the queries listed in the script.
- **How It Works**:
    - **Exporting Credentials**: The script first exports the PostgreSQL credentials (`DB_USER`, `DB_PASSWORD`) so that it can authenticate with the database.
    - **SQL Execution**: The script then uses `psql` to run the SQL commands. These commands are embedded inside the shell script. For example:
      ```bash
      psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $DB_USER -d $DB_NAME -v ON_ERROR_STOP=1 <<-EOSQL
          CREATE DATABASE $DB_NAME;
          -- Other SQL queries here
      EOSQL
      ```
    - **Logger**: After executing the queries, the output is written to a log file (`logger.txt`) to capture the results or any errors.

### folder_runner.sh

- **Purpose**: The script is designed to execute all SQL files in a folder one by one. This is useful if you have multiple SQL files to execute in a specific order.
- **How It Works**:
    - **Move Folder**: The script expects the SQL files to be placed in a specific folder, and it executes each file sequentially.
    - **SQL Execution**: It connects to the PostgreSQL database using the same `psql` command and runs each SQL file.
    - **Logger**: The script logs the responses of each query in the order the files are processed.

---

## 4. Example SQL Query: Loading Data from a CSV File

For example, if you want to load a CSV file into a PostgreSQL table, you can use the following SQL query within the `.sh` file:

```sql
COPY deliveries FROM '/path/to/your/file.csv' DELIMITER ',' CSV HEADER;



## Explanation of CTE Usage in Queries

In some queries, the `WITH` clause (CTE) is used to create a temporary result set (which can be thought of as a table) with specific conditions and filters. The CTE is defined with a table name (for example, `query`) and includes the logic needed to generate the result set.

### How it works:
1. **Creating a Table (Temporary Result Set)**:
   - The `WITH` clause defines a CTE, which acts as a temporary table. This temporary table is created based on the conditions and filters specified within the query.
   - After executing the query, the result of the CTE can be treated like a normal table and used in the rest of the query.

2. **Using the CTE as a "Function"**:
   - Once the CTE is defined, it acts like a function or a reusable result set. It can be referenced multiple times in the main query.
   - The columns from the CTE can be used directly in the query as if they are part of a regular table.
   - The CTE does not store any data permanently, but it exists temporarily for the duration of the query execution.

3. **How the CTE Acts Like a Table**:
   - The CTE can be used in a `SELECT`, `JOIN`, `WHERE`, or other SQL clauses in the main query.
   - The results of the CTE can be further manipulated or filtered, just like you would do with any table or derived result set.
   
### Example:
Here is an example where a CTE is used to create a result set and then the columns from this temporary result set are used in the main query:

```sql
WITH batsman_stats AS (
    SELECT
        d.batsman,
        m.season,
        SUM(d.batsman_runs) AS total_runs,
        COUNT(*) AS total_balls
    FROM deliveries d
    JOIN matches m ON d.match_id = m.id
    GROUP BY d.batsman, m.season
)
SELECT
    batsman,
    season,
    total_runs,
    total_balls,
    ROUND((CAST(total_runs AS DECIMAL) / total_balls) * 100, 2) AS strike_rate
FROM batsman_stats
ORDER BY batsman, season;
