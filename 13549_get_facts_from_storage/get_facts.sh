#!/bin/bash
echo -n "Enter password: "
read PWD
DIRNAME="."

getData(){
#        DIRNAME="$(echo $DATE|awk '{print $5}'|sed 's,:,_,g')_$ID"
#        mkdir -p "$DIRNAME"
#        echo $DATE > "$DIRNAME/$DATE"

  curl -o "$DIRNAME/${sourceData}.xml" -u "yuriy_p@fabit.ru:$PWD" https://parking.fitdev.ru/files/parkingfacts/$sourceData?format=xml
  FNAME=$(cat "$DIRNAME/${sourceData}.xml"|grep '<Id>'|sed 's,\s*<Id>\(.*\)</Id>,\1,')
  echo $?
  if [ $? -ne 0 ] || [ "x$FNAME" == 'x' ]; then
  	echo 'XML parsing error'
  	exit 1
  fi
  mv "$DIRNAME/${sourceData}.xml" "$DIRNAME/${FNAME}.xml"
  curl -o "$DIRNAME/${FNAME}_P.jpg" -u "yuriy_p@fabit.ru:$PWD" https://parking.fitdev.ru/files/parkingfacts/$overviewImage &
  curl -o "$DIRNAME/${FNAME}.jpg" -u "yuriy_p@fabit.ru:$PWD" https://parking.fitdev.ru/files/parkingfacts/$vrpImage &
}

ID="10725257"
DATE="Mon Nov 13 2017 05:59:36 GMT+0000 (UTC)"
overviewImage="5a095f120811005b4ae9f19a"
vrpImage="5a095f120811005b4ae9f199"
sourceData="5a095f120811005b4ae9f197"
getData

ID="10725258"
DATE="Mon Nov 13 2017 06:00:22 GMT+0000 (UTC)"
overviewImage="5a095fc50811005b4ae9f1a1"
vrpImage="5a095fc50811005b4ae9f1a2"
sourceData="5a095fc50811005b4ae9f1a0"
getData

#etc