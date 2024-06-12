#!/bin/sh
set -e

# Function to update config file
update_config_file() {
  local config_path=$1
  local new_ip=$2
  if [ -n "$new_ip" ]; then
    echo "Updating config file: $config_path with IP: $new_ip"
    # Replace IP address in the config file
    sed -i "s/127.0.0.1/$new_ip/g" "$config_path"
  fi
}

case "$1" in
  "frontend")
    if [ -z "$2" ]; then
      echo "Missing parameter: new_ip for frontend"
      exit 1
    fi
    new_ip=$2
    echo "Running frontend command with IP: $new_ip"
    update_config_file "/opt/coins/blockbook/flo/config/blockchaincfg.json" "$new_ip"
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
    echo "Usage: $0 {frontend new_ip|backend}"
    exit 1
    ;;
esac
