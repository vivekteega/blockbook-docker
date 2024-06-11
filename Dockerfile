FROM ubuntu:22.04

# Backend
COPY ./deb-files/backend-flo_0.15.1.1-satoshilabs-1_amd64.deb /opt/backend.deb

RUN apt update && apt install -y /opt/backend.deb
WORKDIR /opt/coins/nodes/flo
RUN sed -i 's/daemon=1/daemon=0/' /opt/coins/nodes/flo/flo.conf

# Frontend
COPY ./deb-files/blockbook-flo_0.4.0_amd64.deb /opt/blockbook.deb

RUN apt update && apt install -y /opt/blockbook.deb
WORKDIR /opt/coins/blockbook/flo

# Execution
COPY ./entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]
