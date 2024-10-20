### **Guide for Using export-then-import.sh**

The `export-then-import.sh` script facilitates exporting collections from one MongoDB instance, backing up the collections on the destination MongoDB instance with a date stamp, and then importing the updated collections into the destination MongoDB.

#### **Steps to Use the Script:**

1. **Ensure Required Files are Present**:
   - The `collections.txt` file must be present in the same directory. This file should contain a list of MongoDB collections (one per line) that need to be exported and imported.

   Example content of `collections.txt`:
   ```
   collection1
   collection2
   ```

2. **Make the Script Executable**:
   Before running the script, make it executable:
   ```bash
   chmod +x export-then-import.sh
   ```

3. **Running the Script**:
   Run the script using the following command:
   ```bash
   ./export-then-import.sh
   ```

4. **Provide Connection Strings**:
   When prompted, provide the MongoDB connection strings for both the **source** and **destination** MongoDB instances. The connection string should be in the following format:

   ```
   mongodb://username:password@host:port/database?authSource=admin
   ```

   - **Source MongoDB**: This is the MongoDB instance from which the collections will be exported.
   - **Destination MongoDB**: This is the MongoDB instance where the collections will be imported, but not before backing up the existing collections.

#### **What the Script Does**:

1. **Step 1: Export Collections from Source**:
   - The script reads the list of collections from the `collections.txt` file.
   - It exports each collection from the **source MongoDB** instance into a `.json` file using `mongoexport`.

2. **Step 2: Backup Collections from Destination**:
   - Before importing the collections into the **destination MongoDB**, the script takes a backup of the existing collections from the destination.
   - The backups are saved as `<collection_name>_<mmddyyyy>.json` (e.g., `collection1_10212024.json`) using `mongoexport`.
   - These backup files allow you to retain a copy of the original data before overwriting it.

3. **Step 3: Import Collections to Destination**:
   - The exported collections from Step 1 are imported into the **destination MongoDB** instance.
   - The script overwrites the destination collections using `mongoimport` (the collections are dropped before importing new data).

#### **Error Handling**:
- The script checks for errors during the export, backup, and import processes. If any of these operations fail, the script will terminate, and an appropriate error message will be displayed.

#### **Backup Naming Convention**:
The backup files are named according to the format:
```
<collection_name>_<mmddyyyy>.json
```
Where:
- `<collection_name>` is the name of the MongoDB collection being backed up.
- `<mmddyyyy>` is the date when the backup was taken, in the format `month-day-year` (e.g., `10212024` for October 21, 2024).

#### **Example Usage**:
```bash
./export-then-import.sh
```
- **Input Source MongoDB Connection String**: 
  ```
  mongodb://user1:password@source_host:27017/sourceDB?authSource=admin
  ```
- **Input Destination MongoDB Connection String**: 
  ```
  mongodb://user2:password@destination_host:27017/destinationDB?authSource=admin
  ```

The script will:
- Export collections from `sourceDB` on the source host.
- Backup existing collections from `destinationDB` on the destination host with a timestamped filename.
- Import the exported collections from the source to the destination, replacing the current data.

#### **Pre-Requisites**:
- Ensure that `mongoexport` and `mongoimport` tools are installed and properly configured on the system where the script is run.
- Make sure that the MongoDB user has sufficient privileges to perform export/import operations.

---