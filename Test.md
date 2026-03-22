# Initial Sync
        Cloud SQL: INSERT INTO public.demo_replication (message) VALUES ('Initial Sync');  
        Verify locally: PGPASSWORD=localpass psql -h 127.0.0.1 -p 5433 -U localadmin -d replica_db -c "SELECT * FROM public.demo_replication ORDER BY id;"  

# Continuous Replication
        INSERT INTO public.demo_replication (message) VALUES ('New Data');
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
