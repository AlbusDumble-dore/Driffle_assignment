# Initial Sync
INSERT INTO demo_replication (message) VALUES ('hello from cloud');  
Check locally: psql -h 127.0.0.1 -p 5433 -U localadmin -d replica_db  

# Continuous Replication
INSERT INTO demo_replication (message) VALUES ('new data');
Verify locally.

# Restart Recovery
docker compose restart postgres-replica
Insert new row → verify replication continues.

# Volume Loss Recovery
docker compose down -v
docker compose up -d
Drop slot
Recreate subscription
Verify data restored
