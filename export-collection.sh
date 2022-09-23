#!/bin/bash
DB=$1
DB1=$2
PASSWD=$3
#DB_COLLECTIONS=$(mongo $DB --quiet --eval "db.getCollectionNames().join(' ')" --host 127.0.0.1:27017 -u the_username -p the_password --authenticationDatabase=admin)
#custom DB collection
DB_COLLECTIONS=(`cat collections.txt`)

for collection in ${DB_COLLECTIONS[@]}}; do
    echo "Exporting $DB1/$collection ..."
    sudo mongoexport --db=$DB1 --collection=$collection --out=$collection.json --host 127.0.0.1:27017 -u $DB -p $PASSWD --authenticationDatabase=admin
done


