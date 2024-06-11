#!/bin/sh
set -e

case "$1" in
  "frontend")
    echo "Running frontend command"
    cd /opt/coins/blockbook/flo
    exec /opt/coins/blockbook/flo/bin/blockbook -blockchaincfg=/opt/coins/blockbook/flo/config/blockchaincfg.json -datadir=/opt/coins/data/flo/blockbook/db -sync -internal=:9066 -public=:9166 -certfile=/opt/coins/blockbook/flo/cert/blockbook -explorer= -log_dir=/opt/coins/blockbook/flo/logs -dbcache=1073741824
    ;;
  "backend")
    echo "Running backend command"
    cd /opt/coins/nodes/flo
    exec /opt/coins/nodes/flo/bin/flod -datadir=/opt/coins/data/flo/backend -conf=/opt/coins/nodes/flo/flo.conf -pid=/run/flo/flo.pid
    ;;
  *)
    echo "Invalid option: $1"
    echo "Usage: $0 {frontend|backend}"
    exit 1
    ;;
esac
