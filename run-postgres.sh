#!/bin/bash

DB_NAME="postgres"
TABLE_NAME="users"
CONTAINER="mydb"

# Boolean query - queries information_schema and returns a single character
# t for true, f fr false (-t for tuples (pairs) only and -A unaligned for clean output)
EXISTS=$(
    docker exec -i "$CONTAINER" \
    psql -U postgres -d "$DB_NAME" -tAc \
    "SELECT to_regclass('public.$TABLE_NAME');"
)

if [[ -n "$EXISTS" ]]; then
    echo "Table '$TABLE_NAME' exists."
else
    echo "Table '$TABLE_NAME' does not exist. Creating it now."
    
    docker exec -i "$CONTAINER" \
    psql -U postgres -d "$DB_NAME" -c "CREATE TABLE $TABLE_NAME ( id SERIAL PRIMARY KEY, name TEXT, email TEXT, age INT ); INSERT INTO users (name, email) VALUES ('Alice', 'alice@test.com', 24), ('Bob', 'bob@test.com', 42), ('Alex', 'alex@test.com', 31); SELECT * FROM users;"

    echo "Table '$TABLE_NAME' created and values inserted."
fi