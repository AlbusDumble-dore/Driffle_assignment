#!/usr/bin/env bash
set -euo pipefail

echo "Waiting for local postgres to be ready..."

until psql -h 127.0.0.1 -p 5433 -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -c "SELECT 1" >/dev/null 2>&1; do
  sleep 1
done

exists="$(psql -h 127.0.0.1 -p 5433 -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -tAc \
  "SELECT 1 FROM pg_catalog.pg_subscription WHERE subname = '${SUB_NAME}';" || true)"

if [ "${exists}" = "1" ]; then
  echo "Subscription ${SUB_NAME} already exists."
  exit 0
fi

echo "Creating subscription ${SUB_NAME}..."

psql -v ON_ERROR_STOP=1 -h 127.0.0.1 -p 5433 -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" <<SQL
CREATE SUBSCRIPTION ${SUB_NAME}
CONNECTION 'host=${PUB_HOST} port=${PUB_PORT} user=${PUB_USER} password=${PUB_PASSWORD} dbname=${PUB_DB} sslmode=${PGSSLMODE}'
PUBLICATION ${PUB_PUBLICATION}
WITH (copy_data = true);
SQL

echo "Subscription created."
