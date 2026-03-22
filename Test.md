# Initial Sync
        Cloud SQL: INSERT INTO public.demo_replication (message) VALUES ('Initial Sync');  
        Verify locally: PGPASSWORD=localpass psql -h 127.0.0.1 -p 5433 -U localadmin -d replica_db -c "SELECT * FROM public.demo_replication ORDER BY id;"  

# Continuous Replication
        INSERT INTO public.demo_replication (message) VALUES ('New Data');
        Verify locally.

# Restart Recovery
        docker compose restart postgres-replica
        docker compose logs -f postgres-replica
        Insert new row → verify replication continues.

# Volume Loss Recovery
        docker compose down -v
        psql "host=127.0.0.1 port=5432 dbname=postgres user=repl_user password=Admin@1234Replication sslmode=disable" \
          -c "SELECT pg_drop_replication_slot('local_sub_01');"
          
        docker compose up -d
        docker compose logs -f postgres-replica
