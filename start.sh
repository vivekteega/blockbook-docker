## Download the Blockchain Bootstrap if set
if [ ! -z "$BLOCKCHAIN_BOOTSTRAP" ]
then
  # download and extract a Blockchain boostrap
  echo 'Downloading Blockchain Bootstrap...'
  RUNTIME="$(date +%s)"
  curl -L $BLOCKCHAIN_BOOTSTRAP -o /opt/coins/data/flo/backend/flosight-bootstrap.tar.gz --progress-bar | tee /dev/null
  RUNTIME="$(($(date +%s)-RUNTIME))"
  echo "Blockchain Bootstrap Download Complete (took ${RUNTIME} seconds)"
  echo 'Extracting Bootstrap...'
  RUNTIME="$(date +%s)"
  tar -xzf /opt/coins/data/flo/backend/flosight-bootstrap.tar.gz -C /data
  RUNTIME="$(($(date +%s)-RUNTIME))"
  echo "Blockchain Bootstrap Extraction Complete! (took ${RUNTIME} seconds)"
  rm -f /opt/coins/data/flo/backend/flosight-bootstrap.tar.gz
  echo 'Erased Blockchain Bootstrap `.tar.gz` file'
  echo "$BLOCKCHAIN_BOOTSTRAP" > /opt/coins/data/flo/backend/bootstrap-url.txt
  ls /data
fi

## Set file persmissions for the bootstrap
chown -R root:root /opt/coins/data/flo/backend/
chmod -R 755 /opt/coins/data/flo/backend/

## Start systemd services
systemctl start backend-flo.service 
systemctl start blockbook-flo.service