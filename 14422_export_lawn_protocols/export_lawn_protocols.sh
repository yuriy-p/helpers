#!/bin/bash
mkdir /tmp/lawn_protocols
chmod 777 /tmp/lawn_protocols
cd /tmp/lawn_protocols
for ID in $(sudo -u postgres psql -tq lawn -c 'select pdf from lawn.protocol where pdf > 0'); do
	NUMBER=$(sudo -u postgres psql -tq lawn -c "select number from lawn.protocol where pdf="$ID | sed 's,\s*,,')
	sudo -u postgres psql -tq lawn -c "select lo_export($ID, '/tmp/lawn_protocols/"$NUMBER".pdf');"
done
