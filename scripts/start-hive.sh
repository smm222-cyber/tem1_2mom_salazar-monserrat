#!/usr/bin/env bash
set -euo pipefail

COMPOSE_FILE="${COMPOSE_FILE:-docker-compose-hive.yml}"

docker compose -f "$COMPOSE_FILE" up -d --build

for attempt in $(seq 1 60); do
  if docker exec namenode hdfs dfsadmin -safemode get 2>/dev/null | grep -q "Safe mode is OFF"; then
    break
  fi
  if [[ "$attempt" -eq 60 ]]; then
    echo "El NameNode no salió del modo seguro a tiempo." >&2
    exit 1
  fi
  sleep 2
done

docker exec namenode hdfs dfs -mkdir -p /user/hive/warehouse
docker exec hive-server bash -c 'rm -f /opt/hive-work/metastore_db/*.lck'

echo "Contenedores iniciados:"
docker compose -f "$COMPOSE_FILE" ps
