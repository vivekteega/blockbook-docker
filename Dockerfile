# Use a base Ubuntu image
FROM ubuntu:20.04

# Set environment variables to avoid interaction during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y \
        git \
        build-essential \
        cmake \
        libtool \
        autoconf \
        automake \
        pkg-config \
        libssl-dev \
        libsqlite3-dev \
        libboost-all-dev \
        libcurl4-openssl-dev \
        golang \
        npm \
        curl

# Clone the blockbook repository
RUN git clone https://github.com/ranchimall/blockbook /opt/blockbook

# Build the blockbook files
WORKDIR /opt/blockbook
RUN make deb-flo

# Install the backend and blockbook services
RUN apt-get install -y ./blockbook-flo*.deb && \
    apt-get install -y ./backend-flo*.deb

# Start the backend service
RUN systemctl start backend-flo.service

# Expose the blockbook port
EXPOSE 9166

# Start the blockbook service
CMD ["systemctl", "start", "blockbook-flo.service"]


