#!/bin/bash

# Prompt for MongoDB connection string
echo "Enter MongoDB connection string (destination):"
read MONGO_URI_DEST

# Ensure the connection string is not empty
if [[ -z "$MONGO_URI_DEST" ]]; then
    echo "Error: MongoDB connection string is required."
    exit 1
fi

# Extract the database name from the connection string
DB1=$(echo "$MONGO_URI_DEST" | sed -n 's#.*/\([a-zA-Z0-9_-]*\)?.*#\1#p')

if [[ -z "$DB1" ]]; then
    echo "Error: Could not extract the database name from the connection string."
    exit 1
fi

# Ensure there are JSON files to import
if [[ ! -n $(find . -name "*.json") ]]; then
    echo "Error: No JSON files found for import."
    exit 1
fi

for FILE in *.json; do
    collection=$(basename "$FILE" .json)
    echo "Importing $collection into $DB1 ..."
    if ! sudo mongoimport --uri="$MONGO_URI_DEST" --collection="$collection" --drop --file="$FILE"; then
        echo "Error: Failed to import collection $collection."
        exit 1
    fi
done

echo "Import process completed successfully."