#!/bin/bash

FACTS_DIR=/tmp/facts

cd /var/www/nci/data/projects/deploy_parking/workspace/ansible
virtualenv -p "/usr/bin/python2.7" "dev/virtualenv" && source dev/virtualenv/bin/activate && dev/virtualenv/bin/pip install --upgrade pip ansible-cmdb

get-facts(){
    cd /var/www/nci/data/projects/deploy_parking/workspace/ansible
    ./do.sh ansible -i ../projects/parking/inventories/cities/production/$1/hosts -m setup --tree $FACTS_DIR/$1/ hardware_servers #all
    cd $FACTS_DIR/$1/
    for FILE in *; do
        mv $FILE $FACTS_DIR/$1_$FILE
    done
    rm -rf $FACTS_DIR/$1
}
get-facts bel
get-facts ek
#etc