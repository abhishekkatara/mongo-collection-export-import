#!/bin/bash
DB=$1
DB1=$2
PASSWD=$3

for FILE in *.json; do
    c= basename $FILE .json;
    sudo mongoimport --db=$DB1 --collection=$c --drop --file=$FILE --host 127.0.0.1:27017 -u $DB -p $PASSWD --authenticationDatabase=admin
done
