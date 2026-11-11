#!/usr/bin/env bash
set -euo pipefail

for query in sql/02-quality-audit.sql sql/03-region-evolution.sql \
  sql/04-rfm.sql sql/05-product-ranking.sql sql/06-discount-impact.sql \
  sql/07-monthly-trends.sql sql/08-pareto.sql; do
  echo "===== $query ====="
  docker exec -i hive-server hive < "$query"
done
