#!/bin/bash

DB_NAME="stage2_db.db"

for sql_file in q*.sql; do
  echo "Running $sql_file..."
  sqlite3 $DB_NAME < "$sql_file"
done

echo "All SQL files executed successfully!"

