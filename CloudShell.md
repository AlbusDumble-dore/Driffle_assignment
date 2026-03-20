Create Cloud SQL instance
gcloud sql instances create mk-postgres-remote \
  --database-version=POSTGRES_18 \
  --edition=ENTERPRISE \
  --cpu=2 \
  --memory=8GB \
  --region=us-central1 \
  --availability-type=ZONAL \
  --storage-size=10GB \
  --database-flags=cloudsql.logical_decoding=on
