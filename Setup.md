# Create Cloud SQL instance  
gcloud sql instances create mk-postgres-remote \
  --database-version=POSTGRES_18 \
  --edition=ENTERPRISE \
  --cpu=2 \
  --memory=8GB \
  --region=us-central1 \
  --availability-type=ZONAL \
  --storage-size=10GB \
  --database-flags=cloudsql.logical_decoding=on

# Create replication user  
gcloud sql users create repl_user \
  --instance=mk-postgres-remote \
  --password='Admin@1234Replication'  

# Setup schema + publication
ALTER ROLE repl_user WITH LOGIN REPLICATION;  

CREATE TABLE demo_replication (  
  id BIGSERIAL PRIMARY KEY,
  message TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE PUBLICATION cloud_pub FOR TABLE demo_replication;

# Local schema create
Logical replication does not replicate schema

# Run Cloud SQL Auth Proxy
./cloud-sql-proxy <INSTANCE_CONNECTION_NAME> --port 5432

# Run Docker subscriber
docker compose up -d

# Cleanup
cd ~/cloudsql-replica
docker compose down -v

gcloud sql instances patch mk-postgres-remote --no-deletion-protection
gcloud sql instances delete mk-postgres-remote
