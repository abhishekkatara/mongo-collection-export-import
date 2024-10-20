#!/bin/bash

# Prompt for MongoDB connection string
echo "Enter MongoDB connection string (source):"
read MONGO_URI_SRC

# Ensure the connection string is not empty
if [[ -z "$MONGO_URI_SRC" ]]; then
    echo "Error: MongoDB connection string is required."
    exit 1
fi

# Extract the database name from the connection string
DB1=$(echo "$MONGO_URI_SRC" | sed -n 's#.*/\([a-zA-Z0-9_-]*\)?.*#\1#p')

if [[ -z "$DB1" ]]; then
    echo "Error: Could not extract the database name from the connection string."
    exit 1
fi

# Custom DB collections from collections.txt
if [[ ! -f "collections.txt" ]]; then
    echo "Error: collections.txt file not found."
    exit 1
fi

DB_COLLECTIONS=(`cat collections.txt`)

for collection in ${DB_COLLECTIONS[@]}; do
    echo "Exporting $DB1/$collection ..."
    if ! sudo mongoexport --uri="$MONGO_URI_SRC" --collection="$collection" --out="$collection.json"; then
        echo "Error: Failed to export collection $collection."
        exit 1
    fi
done

echo "Export process completed successfully."