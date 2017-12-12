#!/bin/bash

err=0
tmpFile=/tmp/afterDeploy.res

for ENV in production/tula staging/centos7 staging/parkingpromo; do
   echo "-----------$ENV------------";
   ./do.sh ansible parking_payment -i ../projects/parking/inventories/cities/$ENV/hosts -m shell -a '"cat {{hostvars[\"parking_payment\"].app_path}}/npack_run_afterDeploy.log"' >$tmpFile  2>/dev/null
   if [ "x$(cat $tmpFile|grep 'Error')" != 'x' ]; then
      echo -e "\033[0;31m!!!!!!!!! ERROR !!!!!!!!!\033[0m"
      err=1
   fi
   echo "$(cat $tmpFile|tail -5)"
   if [ "x$(cat $tmpFile|grep 'migrated')" == 'x' ]; then
      echo -e "\033[0;33m>>> IN PROGRESS >>>\033[0m"
   else
      echo -e "\033[4;32m+++ DONE +++\033[0m"
   fi
   rm -f $tmpFile
done
if [ $err -ne 0 ]; then
   exit 1
fi
