# directory to "stage2"
cd stage2

# creates db
sqlite3 stage2_db.db

# creates tables
sqlite3 stage2_db.db < create_tables.sql

# loads data from csv's into tables
./imports.sh

# runs all sql queries
./run_sql.sh
