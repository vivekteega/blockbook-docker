# syntax=docker/dockerfile:1.3-labs
# Use a base image
FROM cruizba/ubuntu-dind:focal-24.0.6

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget gnupg2 software-properties-common supervisor make git sudo

# Mount the Docker socket from the host into the container
# VOLUME /var/run/docker.sock:/var/run/docker.sock

# Build app (You can add your application build steps here)
RUN git clone https://github.com/ranchimall/blockbook 
WORKDIR /blockbook
RUN --security=insecure cd /blockbook && make all-flo

# Install deb files
RUN sudo apt install -y ./build/backend-flo_0.15.1.1-satoshilabs-1_amd64.deb && \
    sudo apt install -y ./build/blockbook-flo_0.4.0_amd64.deb

# Download deb files
# RUN wget https://github.com/ranchimall/blockbook/releases/download/flo-v0.4.0-ubuntu/backend-flo_0.15.1.1-satoshilabs-1_amd64.deb \
#     https://github.com/ranchimall/blockbook/releases/download/flo-v0.4.0-ubuntu/blockbook-flo_0.4.0_amd64.deb

# Create run flo directory
# RUN mkdir -p /run/flo

# # Create a common group (e.g., flo-group) and set permissions
# RUN groupadd flo-group && \
#     usermod -aG flo-group flo && \
#     usermod -aG flo-group blockbook-flo && \
#     chown :flo-group /run/flo && \
#     chmod 777 /run/flo

# Setting up supervisor configurations (Uncomment and add your configuration files)
COPY alt-helper.sh /
# COPY blockbook-flo.conf /etc/supervisor/conf.d/
# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create log files
# RUN touch /var/log/backend-flo-error.log && \
#     touch /var/log/backend-flo.log && \
#     touch /var/log/blockbook-flo-error.log && \
#     touch /var/log/blockbook-flo.log

# Expose ports
EXPOSE 22 80 9166

# Start supervisord (Uncomment this line)
# CMD ["/usr/bin/supervisord"]

# Start your applications (Uncomment and replace with your application start commands)
#CMD ["/usr/bin/bash", "/alt-helper.sh"]