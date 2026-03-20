# Cloud SQL to Docker PostgreSQL Replication
Replication from a managed cloud database (GCP Cloud SQL) to a local PostgreSQL instance running inside Docker.

# Features - 
- Local DB stays in sync with Cloud SQL.
- Replication resumes automatically after restart.
- Data is re-seeded if local volume is lost.

# Architecture
GCP Cloud SQL (Primary) - PostgreSQL 18 - Publication: cloud_pub<br>
|     (Logical Replication)<br>
Cloud SQL Auth Proxy<br>
|<br>
Docker Container - PostgreSQL Subscriber - Subscription: local_sub_01 - Port: 5433<br>


# Replication Method
PostgreSQL Native Logical Replication using Publisher: Cloud SQL and Subscriber: Docker PostgreSQL.
CREATE PUBLICATION
CREATE SUBSCRIPTION
Handles Initial sync (copy_data = true) and Continuous streaming automatically.

# Persistence Strategy
Data survives container restarts
Docker volume: pgdata
Mounted at: /var/lib/postgresql
