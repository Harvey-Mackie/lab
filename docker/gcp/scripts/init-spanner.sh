#!/bin/bash
# Spanner Emulator Initialization Script
set -e

# Configuration variables - adjust these as needed
PROJECT_ID="my-local-project"
INSTANCE_ID="local-spanner-instance"
SETUP_DIR="/0__lower_setup"

echo "=========================================================="
echo "Google Cloud Spanner Emulator Initialization"
echo "=========================================================="
echo "Project ID: $PROJECT_ID"
echo "Instance ID: $INSTANCE_ID"
echo "Database ID: $DATABASE_ID"
echo "=========================================================="

# Configure gcloud to use the emulator
echo "Configuring gcloud to use the emulator..."
gcloud config set auth/disable_credentials true
gcloud config set project $PROJECT_ID
gcloud config set api_endpoint_overrides/spanner http://spanner-emulator:9020/

# Wait for the emulator to be ready
echo "Waiting for Spanner emulator to be ready..."
RETRY_COUNT=0
MAX_RETRIES=30
RETRY_INTERVAL=2

until curl -s http://spanner-emulator:9020/ >/dev/null || [ $RETRY_COUNT -eq $MAX_RETRIES ]; do
  echo "Attempt $((RETRY_COUNT + 1))/$MAX_RETRIES - Spanner emulator not ready yet, waiting..."
  sleep $RETRY_INTERVAL
  RETRY_COUNT=$((RETRY_COUNT + 1))
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
  echo "Failed to connect to Spanner emulator after $MAX_RETRIES attempts."
  exit 1
fi

echo "Spanner emulator is ready!"

# Create Spanner instance
echo "Creating Spanner instance '$INSTANCE_ID'..."
if gcloud spanner instances describe $INSTANCE_ID --quiet >/dev/null 2>&1; then
  echo "Instance '$INSTANCE_ID' already exists, skipping creation."
else
  gcloud spanner instances create $INSTANCE_ID \
    --config=emulator-config \
    --description="Local development instance" \
    --nodes=1
  echo "Instance '$INSTANCE_ID' created successfully!"
fi

DOMAINS=$(find $SETUP_DIR -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
echo "Found domains - $DOMAINS"

for DOMAIN in $DOMAINS; do
  DATABASE_ID="my-app-database-$DOMAIN"
  DOMAIN_PATH="$SETUP_DIR/$DOMAIN"
  # Create Spanner database
  echo "Creating Spanner database '$DATABASE_ID'..."
  if gcloud spanner databases describe $DATABASE_ID --instance=$INSTANCE_ID --quiet >/dev/null 2>&1; then
    echo "Database '$DATABASE_ID' already exists, skipping creation."
  else
    gcloud spanner databases create $DATABASE_ID \
      --instance=$INSTANCE_ID
    echo "Database '$DATABASE_ID' created successfully!"
  fi
  # Apply database schema
  echo "Applying database schema..."

  # Create schema using DDL statements
  ddl=$(cat $DOMAIN_PATH/ddl.sql)
  gcloud spanner databases ddl update $DATABASE_ID \
    --instance=$INSTANCE_ID \
    --ddl="$ddl"

  echo "Schema created successfully!"

  # Insert schema from dml statements
  dml=$(cat $DOMAIN_PATH/dml.sql) 
  gcloud spanner databases execute-sql $DATABASE_ID \
    --instance=$INSTANCE_ID \
    --sql="$dml"

  echo "Inserted seed data successfully!"

  # Print database details
  echo "=========================================================="
  echo "Spanner emulator initialized and ready to use!"
  echo "Connection details:"
  echo "  Project ID: $PROJECT_ID"
  echo "  Instance ID: $INSTANCE_ID"
  echo "  Database ID: $DATABASE_ID"
  echo "  Endpoint: spanner-emulator:9010 (gRPC), spanner-emulator:9020 (REST)"
  echo "=========================================================="
done





