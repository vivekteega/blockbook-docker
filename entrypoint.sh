#!/bin/sh
set -e

# Paths for frontend bootstrap files
FRONTEND_BOOTSTRAP_URL_FILE="/opt/coins/data/flo/blockbook/bootstrap-url.txt"
FRONTEND_BOOTSTRAP_FILE_HASH_FILE="/opt/coins/data/flo/blockbook/bootstrap-file-hash.txt"

# Paths for backend bootstrap files
BACKEND_BOOTSTRAP_URL_FILE="/opt/coins/data/flo/backend/bootstrap-url.txt"
BACKEND_BOOTSTRAP_FILE_HASH_FILE="/opt/coins/data/flo/backend/bootstrap-file-hash.txt"

# Function to calculate the hash of a file
calculate_file_hash() {
  local file=$1
  sha256sum "$file" | awk '{print $1}'
}

# Function to update config file
update_config_file() {
  local config_path=$1
  local new_ip=$2
  if [ -n "$new_ip" ]; then
    echo "Updating config file: $config_path with IP: $new_ip"
    if ! sed -i "s/127.0.0.1/$new_ip/g" "$config_path"; then
      echo "Failed to update config file: $config_path"
      exit 1
    fi
  fi
}

# Function to handle bootstrap from URL
handle_bootstrap_url() {
  local bootstrap_url=$1
  local destination_dir=$2
  local url_file=$3
  local bootstrap_file=$4

  if [ -z "$bootstrap_url" ]; then
    echo "No bootstrap URL provided, skipping download."
    return
  fi

  if [ -f "$url_file" ]; then
    local existing_url
    existing_url=$(cat "$url_file")
    if [ "$existing_url" = "$bootstrap_url" ]; then
      echo "Bootstrap URL already processed, skipping download and extraction."
      return
    fi
  fi

  echo "Downloading bootstrap file from: $bootstrap_url"
  curl -L -o "/tmp/$bootstrap_file" "$bootstrap_url"
  echo "Cleaning and extracting bootstrap file to: $destination_dir"
  mkdir -p "$destination_dir"
  rm -rf "$destination_dir"/*
  tar -xzvf "/tmp/$bootstrap_file" -C "$destination_dir"
  rm "/tmp/$bootstrap_file"

  echo "$bootstrap_url" > "$url_file"
}

# Function to handle bootstrap from file
handle_bootstrap_file() {
  local bootstrap_file=$1
  local destination_dir=$2
  local hash_file=$3

  if [ -z "$bootstrap_file" ] || [ ! -f "$bootstrap_file" ]; then
    echo "No valid bootstrap file provided, skipping extraction."
    return
  fi

  local new_hash
  new_hash=$(calculate_file_hash "$bootstrap_file")

  if [ -f "$hash_file" ]; then
    local existing_hash
    existing_hash=$(cat "$hash_file")
    if [ "$existing_hash" = "$new_hash" ]; then
      echo "Bootstrap file already processed, skipping extraction."
      return
    fi
  fi

  echo "Using bootstrap file: $bootstrap_file"
  echo "Cleaning and extracting bootstrap file to: $destination_dir"
  mkdir -p "$destination_dir"
  rm -rf "$destination_dir"/*
  tar -xzf "$bootstrap_file" -C "$destination_dir"

  echo "$new_hash" > "$hash_file"
}

case "$1" in
  "frontend")
    if [ -z "$2" ]; then
      echo "Missing parameter: new_ip for frontend"
      exit 1
    fi
    new_ip=$2
    echo "Running frontend command with IP: $new_ip"
    
    if [ -n "$BOOTSTRAP_FILE" ] && [ -f "$BOOTSTRAP_FILE" ]; then
      handle_bootstrap_file "$BOOTSTRAP_FILE" "/opt/coins/data/flo/blockbook" "$FRONTEND_BOOTSTRAP_FILE_HASH_FILE"
    elif [ -n "$BOOTSTRAP_URL" ]; then
      handle_bootstrap_url "$BOOTSTRAP_URL" "/opt/coins/data/flo/blockbook" "$FRONTEND_BOOTSTRAP_URL_FILE" "bootstrap-frontend.tar.gz"
    fi

    update_config_file "/opt/coins/blockbook/flo/config/blockchaincfg.json" "$new_ip"
    cd /opt/coins/blockbook/flo
    exec /opt/coins/blockbook/flo/bin/blockbook -blockchaincfg=/opt/coins/blockbook/flo/config/blockchaincfg.json -datadir=/opt/coins/data/flo/blockbook/db -sync -internal=:9066 -public=:9166 -certfile=/opt/coins/blockbook/flo/cert/blockbook -explorer= -log_dir=/opt/coins/blockbook/flo/logs -dbcache=1073741824
    ;;
  "backend")
    echo "Running backend command"
    
    if [ -n "$BOOTSTRAP_FILE" ] && [ -f "$BOOTSTRAP_FILE" ]; then
      handle_bootstrap_file "$BOOTSTRAP_FILE" "/opt/coins/data/flo/backend" "$BACKEND_BOOTSTRAP_FILE_HASH_FILE"
    elif [ -n "$BOOTSTRAP_URL" ]; then
      handle_bootstrap_url "$BOOTSTRAP_URL" "/opt/coins/data/flo/backend" "$BACKEND_BOOTSTRAP_URL_FILE" "bootstrap-backend.tar.gz"
    fi

    cd /opt/coins/nodes/flo
    exec /opt/coins/nodes/flo/bin/flod -datadir=/opt/coins/data/flo/backend -conf=/opt/coins/nodes/flo/flo.conf -pid=/run/flo/flo.pid
    ;;
  *)
    echo "Invalid option: $1"
    echo "Usage: $0 {frontend new_ip|backend}"
    exit 1
    ;;
esac
