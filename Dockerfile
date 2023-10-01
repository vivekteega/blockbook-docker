# Use a base image
FROM nestybox/ubuntu-focal-systemd-docker

# Install necessary packages
RUN apt update && \
    apt install -y wget gnupg2 software-properties-common unzip

# Download deb files
RUN wget https://github.com/ranchimall/blockbook-docker/archive/main.zip && unzip main.zip
RUN cd blockbook-docker-main && sudo apt install -y ./deb-files/dind_backend-flo_0.15.1.1-satoshilabs-1_amd64.deb && sudo apt install -y ./deb-files/dind_blockbook-flo_0.4.0_amd64.deb

# Expose ports
EXPOSE 22 80 9166

# Start your applications (Uncomment and replace with your application start commands)
CMD ["/lib/systemd/systemd"]