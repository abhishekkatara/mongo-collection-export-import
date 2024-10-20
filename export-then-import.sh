#!/bin/bash

# Prompt for source and destination MongoDB connection strings

echo "Enter MongoDB connection string (source):"
read MONGO_URI_SRC

# Ensure the source connection string is not empty
if [[ -z "$MONGO_URI_SRC" ]]; then
    echo "Error: Source MongoDB connection string is required."
    exit 1
fi

echo "Enter MongoDB connection string (destination):"
read MONGO_URI_DEST

# Ensure the destination connection string is not empty
if [[ -z "$MONGO_URI_DEST" ]]; then
    echo "Error: Destination MongoDB connection string is required."
    exit 1
fi

# Extract the source and destination database names
DB_SRC=$(echo "$MONGO_URI_SRC" | sed -n 's#.*/\([a-zA-Z0-9_-]*\)?.*#\1#p')
DB_DEST=$(echo "$MONGO_URI_DEST" | sed -n 's#.*/\([a-zA-Z0-9_-]*\)?.*#\1#p')

if [[ -z "$DB_SRC" ]]; then
    echo "Error: Could not extract the source database name from the connection string."
    exit 1
fi

if [[ -z "$DB_DEST" ]]; then
    echo "Error: Could not extract the destination database name from the connection string."
    exit 1
fi

# Step 1: Export collections from the source MongoDB
echo "Starting export process..."

# Custom DB collections from collections.txt
if [[ ! -f "collections.txt" ]]; then
    echo "Error: collections.txt file not found."
    exit 1
fi

DB_COLLECTIONS=(`cat collections.txt`)

for collection in ${DB_COLLECTIONS[@]}; do
    echo "Exporting $DB_SRC/$collection ..."
    if ! sudo mongoexport --uri="$MONGO_URI_SRC" --collection="$collection" --out="$collection.json"; then
        echo "Error: Failed to export collection $collection."
        exit 1
    fi
done

echo "Export process completed successfully."

# Step 2: Backup collections in the destination MongoDB before importing

echo "Starting backup process before importing collections..."

# Get the current date in mmddyyyy format
DATE=$(date +"%m%d%Y")

for FILE in *.json; do
    collection=$(basename "$FILE" .json)
    backup_file="${collection}_$DATE.json"
    echo "Backing up $collection as $backup_file ..."
    
    if ! sudo mongoexport --uri="$MONGO_URI_DEST" --collection="$collection" --out="$backup_file"; then
        echo "Error: Failed to backup collection $collection."
        exit 1
    fi
done

echo "Backup process completed successfully."

# Step 3: Import collections into the destination MongoDB
echo "Starting import process..."

# Ensure there are JSON files to import
if [[ ! -n $(find . -name "*.json") ]]; then
    echo "Error: No JSON files found for import."
    exit 1
fi

for FILE in *.json; do
    collection=$(basename "$FILE" .json)
    echo "Importing $collection into $DB_DEST ..."
    if ! sudo mongoimport --uri="$MONGO_URI_DEST" --collection="$collection" --drop --file="$FILE"; then
        echo "Error: Failed to import collection $collection."
        exit 1
    fi
done

echo "Import process completed successfully."