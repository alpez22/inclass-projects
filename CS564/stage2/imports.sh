#!/bin/bash

DB="stage2_db.db"

sqlite3 $DB <<EOF
.mode csv

.import '| tail -n +2 ~/CS564/stage2/regions.csv' regions

.import '| tail -n +2 ~/CS564/stage2/countries.csv' countries

.import '| tail -n +2 ~/CS564/stage2/locations.csv' locations

.import '| tail -n +2 ~/CS564/stage2/departments.csv' departments

.import '| tail -n +2 ~/CS564/stage2/jobs.csv' jobs

.import '| tail -n +2 ~/CS564/stage2/employees.csv' employees

.import '| tail -n +2 ~/CS564/stage2/dependents.csv' dependents
EOF

echo "CSV import completed!"

