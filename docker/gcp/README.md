# Local GCP Development Environment

This repo provides a Docker Compose setup for local development with Google Cloud Spanner and Cloud Storage emulators, supporting multiple domain-specific databases.

## ✨ Features

- Google Cloud Spanner emulator with multi-database support
- Google Cloud Storage emulator (wip)
- Domain-driven database organization
- Automatic schema and data initialization
- Simple configuration via Docker Compose

## 📂 Directory Structure
```
.
├── 0__lower_setup             # Main setup directory
│   ├── school                 # Domain 1 (becomes database my-app-database-school)
│   │   ├── ddl.sql            # DDL statements for school database
│   │   └── dml.sql            # DML statements for school database
│   └── zenzone                # Domain 2 (becomes database my-app-database-zenzone)
│       ├── ddl.sql            # DDL statements for zenzone database
│       └── dml.sql            # DML statements for zenzone database
├── docker-compose.yml         # Main configuration file
├── scripts
│   └── init-spanner.sh        # Script to initialize Spanner instance and databases
└── storage-data               # Directory where Cloud Storage emulator data will be stored
```

## 🛠️ How It Works

The initialization script:

1. Configures gcloud to work with the emulator
2. Creates a single Spanner instance named `local-spanner-instance`
3. Scans the `0__lower_setup` directory for domain folders
4. For each domain (folder):
   - Creates a database named `my-app-database-{domain}`
   - Applies the DDL from `{domain}/ddl.sql`
   - Applies the DML from `{domain}/dml.sql`

### 🆕 How to Add a New Domain

Adding a new domain database is simple:

1. Create a new folder in the `0__lower_setup` directory with your domain name:

   ```bash
   mkdir -p 0__lower_setup/new-domain
   ```

2. Create the DDL and DML files for the new domain:

   ```bash
   touch 0__lower_setup/new-domain/ddl.sql
   touch 0__lower_setup/new-domain/dml.sql
   ```

3. Add your schema definitions to `ddl.sql`:

   ```sql
   -- Example schema for new-domain
   CREATE TABLE Users (
     UserId STRING(36) NOT NULL,
     Email STRING(255) NOT NULL,
     Name STRING(100),
     PRIMARY KEY (UserId)
   );
   ```

4. Add your initial data to `dml.sql`:

   ```sql
   -- Example data for new-domain
   INSERT INTO Users (
     UserId, 
     Email, 
     Name
   ) VALUES (
     "user-001", 
     "user@example.com", 
     "Test User"
   );
   ```

5. Restart the services to apply the changes:

   ```bash
   docker-compose down
   docker-compose up -d
   ```

The new database `my-app-database-new-domain` will be automatically created with your schema and data.

### 🔌 How to Connect to Databases

#### Using VSCode SQLTools

1. Install the "Google Cloud Spanner Driver" extension from the VSCode marketplace
2. Open the SQLTools sidebar and click the "Add New Connection" button
3. Choose "Google Cloud Spanner Driver" from the list
4. Configure the connection:
   - Connection name: `Local Emulator - School`
   - Project ID: `my-local-project`
   - Instance ID: `local-spanner-instance`
   - Database ID: `my-app-database-school`
   - ✅ Check the "Connect to emulator" box
5. Click "Test Connection" to verify it works
6. Save the connection and you're ready to query your database

## ⚠️ Limitations
- The Spanner emulator stores data in memory, so all data will be lost when containers restart
- Authentication and IAM are not emulated as the image does not support this.