#!/bin/bash

#set -x

frontDbUrl=$1
storageDbUrl=$2

echo '
var date1 = new Date("2018-10-01T00:00:00")
db.getCollection("fs.files").find(
	{
		"metadata.scope":"parkingFacts", "length":0 , uploadDate: {
			$gte: date1
		}
	}
	).forEach( function(obj) {
	  print(obj._id.valueOf());
	});
' > /tmp/mongo_shell_script.js


mongo --quiet $1 /tmp/mongo_shell_script.js > /tmp/factsInStorage
if [ $? -ne 0 ]; then
	(>&2 echo Failed to connect to mongodb)
	exit 1
fi

# #-----------------------get facts based on ids in storage

# echo '
# db.parkingFacts.find({"files.vrpImage":{ $in:[
# ' > /tmp/mongo_shell_script_getfacts.js

# cat /tmp/factsInStorage| while IFS='' read -r line || [[ -n "$line" ]]; do
# 	echo "\"$line\"," >> /tmp/mongo_shell_script_getfacts.js
# done

# echo '
# ]}}).forEach(function(obj){
# 	printjson(obj);
# })
# ' >> /tmp/mongo_shell_script_getfacts.js


# mongo --quiet $2 /tmp/mongo_shell_script_getfacts.js > /tmp/facts
# if [ $? -ne 0 ]; then
# 	(>&2 echo Failed to connect to mongodb)
# 	exit 1
# fi

#-------------------------get fact ids and dates based on ids in storage for not rejected facts

echo '
db.parkingFacts.find({"status": {$not: /^rejected$/},"files.vrpImage":{ $in:[
' > /tmp/mongo_shell_script_getfacts.js

cat /tmp/factsInStorage| while IFS='' read -r line || [[ -n "$line" ]]; do
	echo "\"$line\"," >> /tmp/mongo_shell_script_getfacts.js
done

echo '
]}}).forEach(function(obj){
	print(obj._id+" "+obj.processed+" "+obj.status+" "+new Date(obj.date));
})
' >> /tmp/mongo_shell_script_getfacts.js


mongo --quiet $2 /tmp/mongo_shell_script_getfacts.js > /tmp/fact_ids_dates
if [ $? -ne 0 ]; then
	(>&2 echo Failed to connect to mongodb)
	exit 1
fi

# #---------------------get sessions based on fact ids in storage

# echo '
# db.parkingSessions.find({$or: [{"firstFact.files.vrpImage":{ $in:[
# ' > /tmp/mongo_shell_script_getsessions.js

# cat /tmp/factsInStorage| while IFS='' read -r line || [[ -n "$line" ]]; do
# 	echo "\"$line\"," >> /tmp/mongo_shell_script_getsessions.js
# done

# echo ']}},{"lastFact.files.vrpImage":{ $in:[
# ' >> /tmp/mongo_shell_script_getsessions.js

# cat /tmp/factsInStorage| while IFS='' read -r line || [[ -n "$line" ]]; do
# 	echo "\"$line\"," >> /tmp/mongo_shell_script_getsessions.js
# done

# echo '
# ]}}]}).forEach(function(obj){
# 	printjson(obj);
# })
# ' >> /tmp/mongo_shell_script_getsessions.js

# #-------------------get session ids and dates based on fact ids in storage

# echo '
# db.parkingSessions.find({$or: [{"firstFact.files.vrpImage":{ $in:[
# ' > /tmp/mongo_shell_script_getsessions.js

# cat /tmp/factsInStorage| while IFS='' read -r line || [[ -n "$line" ]]; do
# 	echo "\"$line\"," >> /tmp/mongo_shell_script_getsessions.js
# done

# echo ']}},{"lastFact.files.vrpImage":{ $in:[
# ' >> /tmp/mongo_shell_script_getsessions.js

# cat /tmp/factsInStorage| while IFS='' read -r line || [[ -n "$line" ]]; do
# 	echo "\"$line\"," >> /tmp/mongo_shell_script_getsessions.js
# done

# echo '
# ]}}]}).forEach(function(obj){
# 	print(obj._id+" "+obj.status+" "+new Date(obj.lastFact.date));
# })
# ' >> /tmp/mongo_shell_script_getsessions.js


# mongo --quiet $2 /tmp/mongo_shell_script_getsessions.js > /tmp/sessions_id_date
# if [ $? -ne 0 ]; then
# 	(>&2 echo Failed to connect to mongodb)
# 	exit 1
# fi



exit 0

