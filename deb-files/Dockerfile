# Use the official Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set the DEBIAN_FRONTEND environment variable to noninteractive to avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and clean up the apt cache to reduce image size
RUN apt-get update && \
    #apt-get install -y supervisor && \
    rm -rf /var/lib/apt/lists/*

# Copy the .deb package for backend-flo into the container
COPY dind_backend-flo_0.15.1.1-satoshilabs-1_amd64.deb /tmp/backend-flo.deb

# Update the package list, install the .deb package, and remove the .deb file to reduce image size
RUN apt-get update && \
    apt-get install -y /tmp/backend-flo.deb && \
    rm /tmp/backend-flo.deb

# Expose the RPC port for the backend
EXPOSE 8066

# Copy the .deb package for blockbook-flo into the container
COPY dind_blockbook-flo_0.4.0_amd64.deb /tmp/blockbook-flo.deb

# Update the package list, install the .deb package, and remove the .deb file to reduce image size
RUN apt-get update && \
    apt-get install -y /tmp/blockbook-flo.deb && \
    rm /tmp/blockbook-flo.deb

# Expose ports for the frontend
EXPOSE 9166
EXPOSE 9066

# Copy supervisor configuration
#COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Declare volumes for persistence
VOLUME /opt/coins

# Start the service and keep the container running by tailing the log file
#CMD /bin/bash -c "/opt/coins/nodes/flo/bin/flod -datadir=/opt/coins/data/flo/backend -conf=/opt/coins/nodes/flo/flo.conf -pid=/run/flo/flo.pid && tail -f /opt/coins/data/flo/backend/debug.log && /opt/coins/blockbook/flo/bin/blockbook -blockchaincfg=/opt/coins/blockbook/flo/config/blockchaincfg.json -datadir=/opt/coins/data/flo/blockbook/db -sync -internal=:9066 -public=:9166 -certfile=/opt/coins/blockbook/flo/cert/blockbook -explorer= -log_dir=/opt/coins/blockbook/flo/logs -dbcache=1073741824"

CMD ["tail", "-f", "/dev/null"]
# Start supervisor
#CMD ["/usr/bin/supervisord"]


# check logs of the services
# tail -f /opt/coins/data/flo/backend/debug.log
# tail -f /opt/coins/blockbook/flo/logs/blockbook.INFO
