#!/usr/bin/env bash
set -euo pipefail

COMPOSE_FILE="${COMPOSE_FILE:-docker-compose-hive.yml}"
CSV_FILE="${1:-Sample - Superstore.csv}"

if [[ ! -f "$CSV_FILE" ]]; then
  echo "No se encontró el archivo CSV: $CSV_FILE" >&2
  exit 1
fi

docker cp "$CSV_FILE" namenode:/tmp/superstore.csv
docker exec namenode hdfs dfs -rm -f /user/hive/warehouse/superstore.csv >/dev/null 2>&1 || true
docker exec namenode hdfs dfs -put /tmp/superstore.csv /user/hive/warehouse/
docker exec hive-server bash -c 'rm -f /opt/hive-work/metastore_db/*.lck'
docker exec -i hive-server hive < sql/01-create-superstore.sql

echo "Datos cargados desde: $CSV_FILE"
