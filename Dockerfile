FROM ubuntu:latest
WORKDIR /app
COPY . /app
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip
RUN git clone https://github.com/trezor/blockbook.git
WORKDIR /app/blockbook

