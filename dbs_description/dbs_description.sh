#!/bin/bash

# Find __MONGO_SHELL_JS__ maker, write it to separate file
JS_SCRIPT=$(awk '/^__MONGO_SHELL_JS__/ {print NR + 1; exit 0; }' "${0}")
tail -n+${JS_SCRIPT} "${0}" > ./mongo_dbs_discription.js

echo ====================== MongoDB databases structure ======================
mongo --quiet $1 ./mongo_dbs_discription.js
if [ $? -ne 0 ]; then
	(>&2 echo Failed to connect to mongodb)
	exit 1
fi

echo
echo ====================== PostgreSQL databases structure ======================

DBLIST=$(sudo -u postgres psql -qtc 'SELECT datname FROM pg_database WHERE datistemplate = false;' 2>/dev/null)

for DB in $DBLIST; do
	echo ---------------- Database: $DB
	TABLES=$(sudo -u postgres psql $DB -qtc "SELECT table_name as show_tables FROM information_schema.tables \
		WHERE table_type = 'BASE TABLE' AND table_schema NOT IN ('pg_catalog', 'information_schema');" 2>/dev/null)
  for TABLE in $TABLES; do
  	echo Table: $TABLE
  	sudo -u postgres psql $DB -qc "select table_name, column_name, data_type, is_nullable \
 			from INFORMATION_SCHEMA.COLUMNS \
 			where table_name IN (SELECT table_name as show_tables \
 				FROM information_schema.tables \
 				WHERE table_type = 'BASE TABLE' AND table_schema NOT IN ('pg_catalog', 'information_schema')) \
 				ORDER by table_name, column_name;" 2>/dev/null |grep -v 'rows)'
  done
done

exit 0

__MONGO_SHELL_JS__
db.adminCommand( { listDatabases: 1, nameOnly: true } ).databases.forEach(
	function(database)
		{
			if (database.name != 'local') {
				validatorsExist=false;
				print('---------------- Database: ' + database.name);
				currentDb = db.getSiblingDB(database.name);
				validators=currentDb.validators.find().forEach(function(validator){
					printjson(validator);
					validatorsExist=true;
				})
				if (validatorsExist == false) {
					currentDb.getCollectionNames().forEach(function(collection){
						print('Collection: ' + collection);
						printjson(currentDb.getCollection(collection).findOne());
					})
				}
			}
		}
	)
