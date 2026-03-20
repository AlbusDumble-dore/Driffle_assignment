# Cloud SQL to Docker PostgreSQL Replication
Replication from a managed cloud database (GCP Cloud SQL) to a local PostgreSQL instance running inside Docker.

# Features - 
- Local DB stays in sync with Cloud SQL.
- Replication resumes automatically after restart.
- Data is re-seeded if local volume is lost.

# Architecture
GCP Cloud SQL (Primary) - PostgreSQL 18 - Publication: cloud_pub  
→    (Logical Replication)  
Cloud SQL Auth Proxy - localhost:5432
→  
Docker Container - PostgreSQL Subscriber - Subscription: local_sub_01 - Port: 5433 - Volume: pgdata  


# Replication Method
PostgreSQL Native Logical Replication using Publisher: Cloud SQL and Subscriber: Docker PostgreSQL.  
CREATE PUBLICATION  
CREATE SUBSCRIPTION  
Handles Initial sync (copy_data = true) and Continuous streaming automatically.  

# Persistence Strategy  
Data survives container restarts  
Docker volume: pgdata  
Mounted at: /var/lib/postgresql  

# Restart Recovery  //Add this to test.md
1. Container Restart: docker compose restart postgres-replica  
     Replication resumes as subscription already exists in local DB, PostgreSQL automatically reconnects.  
2. Volume Loss: docker compose down -v  
     Local DB deleted, subscription lost. Remote replication slot still exists.  
     Drop stale replication slot: SELECT pg_drop_replication_slot('local_sub_01');  
     Recreate subscription:  
      CREATE SUBSCRIPTION local_sub_01  
      CONNECTION 'host=127.0.0.1 port=5432 user=repl_user password=... dbname=postgres sslmode=disable'  
      PUBLICATION cloud_pub  
      WITH (copy_data = true);  

# Setup  
1. GCP Cloud Shell for local DB - Preinstalled docker.
2. Create Cloud SQL instance.
3. Create replication user
4. Setup schema + publication
5. .env for docker compose
6. Local schema create
7. Run Cloud SQL Auth Proxy
8. Run Docker subscriber
9. Cleanup


# Test
1. Initial Sync
2. Continuous Replication
3. Restart Recovery
4. Volume Loss Recovery
