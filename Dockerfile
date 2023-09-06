# Use a base image
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y gnupg2 && \
    apt-get install -y software-properties-common

# Download the pre-built files from GitHub releases
RUN wget https://github.com/ranchimall/blockbook/releases/download/flo-v0.4.0-ubuntu/backend-flo_0.15.1.1-satoshilabs-1_amd64.deb && \
    wget https://github.com/ranchimall/blockbook/releases/download/flo-v0.4.0-ubuntu/blockbook-flo_0.4.0_amd64.deb
# Install the downloaded packages
RUN apt install -y ./backend-flo_0.15.1.1-satoshilabs-1_amd64.deb && \
    apt install -y ./blockbook-flo_0.4.0_amd64.deb

# Clean up downloaded packages
RUN rm -f ./backend-flo_0.15.1.1-satoshilabs-1_amd64.deb && \
    rm -f ./blockbook-flo_0.4.0_amd64.deb

# Expose the port for the Blockbook web interface
EXPOSE 9166

# Start the Blockbook service
CMD ["/usr/local/bin/blockbook", "--config", "/etc/blockbook/blockbook-flo.cfg"]