# Use a base image
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y gnupg2 && \
    apt-get install -y software-properties-common && \
    apt install supervisor

# Download the pre-built files from GitHub releases
RUN wget https://github.com/ranchimall/blockbook/releases/download/flo-v0.4.0-ubuntu/backend-flo_0.15.1.1-satoshilabs-1_amd64.deb && \
    wget https://github.com/ranchimall/blockbook/releases/download/flo-v0.4.0-ubuntu/blockbook-flo_0.4.0_amd64.deb

# Install the downloaded packages
RUN apt install -y ./backend-flo_0.15.1.1-satoshilabs-1_amd64.deb && \
    apt install -y ./blockbook-flo_0.4.0_amd64.deb

# Clean up downloaded packages
RUN rm -f ./backend-flo_0.15.1.1-satoshilabs-1_amd64.deb && \
    rm -f ./blockbook-flo_0.4.0_amd64.deb

# Setting up supervisor configurations
#COPY backend-flo.conf /etc/supervisor/conf.d/
#COPY blockbook-flo.conf /etc/supervisor/conf.d/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN touch /var/log/backend-flo-error.log && touch /var/log/backend-flo.log && touch /var/log/blockbook-flo-error.log && touch /var/log/blockbook-flo.log
#RUN supervisorctl reread && supervisorctl update

# Expose the port for the Blockbook web interface
EXPOSE 9166

# Start the Blockbook service
#CMD ["/usr/local/bin/blockbook", "--config", "/etc/blockbook/blockbook-flo.cfg"]
#CMD ["/opt/coins/nodes/flo/bin/flod -datadir=/opt/coins/data/flo/backend -conf=/opt/coins/nodes/flo/flo.conf -pid=/run/flo/flo.pid"]

EXPOSE 22 80
CMD ["/usr/bin/supervisord"]