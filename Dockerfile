FROM ubuntu:22.04

# Backend
COPY ./deb-files/backend-flo_0.15.1.1-satoshilabs-1_amd64.deb /opt/backend.deb
COPY ./deb-files/blockbook-flo_0.4.0_amd64.deb /opt/blockbook.deb

RUN apt update && apt install -y /opt/backend.deb /opt/blockbook.deb curl && \
    sed -i 's/daemon=1/daemon=0/' /opt/coins/nodes/flo/flo.conf && \
    sed -i '/rpcport=8066/a rpcallowip=0.0.0.0/0' /opt/coins/nodes/flo/flo.conf && \
    echo "addnode=ramanujam.ranchimall.net" >> /opt/coins/nodes/flo/flo.conf && \
    echo "addnode=turing.ranchimall.net" >> /opt/coins/nodes/flo/flo.conf && \
    echo "addnode=stevejobs.ranchimall.net" >> /opt/coins/nodes/flo/flo.conf && \
    echo "addnode=brahmagupta.ranchimall.net" >> /opt/coins/nodes/flo/flo.conf && \
    echo "addnode=feynman.ranchimall.net" >> /opt/coins/nodes/flo/flo.conf

WORKDIR /opt/coins/blockbook/flo

# Execution
COPY ./entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]
