# Create Cloud SQL primary instance  
        gcloud sql instances create mk-postgres-remote \  
        --database-version=POSTGRES_18 \  
        --edition=ENTERPRISE \  
        --cpu=2 \  
        --memory=8GB \  
        --region=us-central1 \  
        --availability-type=ZONAL \  
        --storage-size=10GB \  
        --storage-type=SSD \  
        --database-flags=cloudsql.logical_decoding=on \  
        --root-password='Admin@123'  

# Create replication user  
        gcloud sql users create repl_user \  
          --instance=mk-postgres-remote \  
          --password='Admin@1234Replication'  

# Configure Primary Database - schema & publication
        ALTER ROLE repl_user WITH LOGIN REPLICATION;  
  
        CREATE TABLE IF NOT EXISTS public.demo_replication (  
          id BIGSERIAL PRIMARY KEY,  
          message TEXT NOT NULL,  
          created_at TIMESTAMPTZ NOT NULL DEFAULT now()  
        );  
  
        GRANT SELECT ON TABLE public.demo_replication TO repl_user;  
  
        CREATE PUBLICATION cloud_pub FOR TABLE public.demo_replication;  

# Start the Cloud SQL Auth Proxy.
        curl -o cloud-sql-proxy \
          https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.21.1/cloud-sql-proxy.linux.amd64
        
        chmod +x cloud-sql-proxy
        
        ./cloud-sql-proxy gcp-keng01:us-central1:mk-postgres-remote --port 5432
        
# Configure Docker Subscriber
        .env
        docker-compose.yml
        init/00-schema.sql
        init/01-create-subscription.sh
        chmod +x init/

# Cleanup
pkill cloud-sql-proxy

cd ~/cloudsql-replica
docker compose down -v

gcloud sql instances patch mk-postgres-remote --no-deletion-protection
gcloud sql instances delete mk-postgres-remote
