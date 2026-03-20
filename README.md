# Driffle_assignment - Cloud SQL to Docker PostgreSQL Replication
Replication from a managed cloud database (GCP Cloud SQL) to a local PostgreSQL instance running inside Docker.

# Features - 
- Local DB stays in sync with Cloud SQL.
- Replication resumes automatically after restart.
- Data is re-seeded if local volume is lost.

# Architecture
GCP Cloud SQL (Primary) - PostgreSQL 18 - Publication: cloud_pub
|     (Logical Replication)
Cloud SQL Auth Proxy
|
Docker Container - PostgreSQL Subscriber - Subscription: local_sub_01 - Port: 5433

# Replication Method
