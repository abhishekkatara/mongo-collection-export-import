#!/bin/bash
echo "Enter Host IP"
read HOST
echo "Enter Login Username"
read USER
echo "Enter Login Password"
read PASSWD
echo "Enter DB name"
read DB1
#DB_COLLECTIONS=$(mongo $DB --quiet --eval "db.getCollectionNames().join(' ')" --host 127.0.0.1:27017 -u the_username -p the_password --authenticationDatabase=admin)
#custom DB collection
DB_COLLECTIONS=(`cat collections.txt`)

for collection in ${DB_COLLECTIONS[@]}}; do
    echo "Exporting $DB1/$collection ..."
    sudo mongoexport --db=$DB1 --collection=$collection --out=$collection.json --host $HOST:27017 -u $USER -p $PASSWD --authenticationDatabase=admin
done


