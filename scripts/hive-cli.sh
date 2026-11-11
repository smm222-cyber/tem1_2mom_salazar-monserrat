#!/usr/bin/env bash
set -euo pipefail

docker exec -it hive-server bash -lc \
  'export HADOOP_HEAPSIZE=${HADOOP_HEAPSIZE:-2048}; cd /opt/hive-work; hive'
