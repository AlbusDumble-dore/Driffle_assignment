# Cloud SQL to Docker PostgreSQL Replication
Replication from a managed cloud database (GCP Cloud SQL) to a local PostgreSQL instance running inside Docker.

# Features - 
- Local DB stays in sync with Cloud SQL.
- Replication resumes automatically after restart.
- Data is re-seeded if local volume is lost.

# Architecture
GCP Cloud SQL (Primary) - PostgreSQL 18   
▼  
▼    (Logical Replication - Publication: cloud_pub)  
▼  
Cloud SQL Auth Proxy - localhost:5432  
▼    
▼  
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

# Restart Recovery  
1. Container Restart:  
     Replication resumes as subscription already exists in local DB, PostgreSQL automatically reconnects.  
2. Volume Loss:  
     Local DB deleted, subscription lost.  
     Remote replication slot still exists, Drop stale replication slot.


# [Setup](Setup.md)  
1. GCP Cloud Shell for local DB - Preinstalled docker.
2. Create Cloud SQL primary instance & relication user.  
3. Configure Primary Database - schema & publication.  
4. Start the Cloud SQL Auth Proxy.  
5. Configure Docker Subscriber - .env, docker-compose.yml, init scripts.  
6. Start Subscriber.  
9. Cleanup.  


# [Test](Test.md)
1. Initial Sync
2. Continuous Replication
3. Restart Recovery
4. Volume Loss Recovery
