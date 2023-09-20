cd /blockbook && sudo make all-flo

#1. Install deb files 
cd /blockbook/build && sudo apt install -y ./backend-flo_0.15.1.1-satoshilabs-1_amd64.deb
cd /blockbook/build && sudo apt install -y ./blockbook-flo_0.4.0_amd64.deb

#2. create run flo dir
mkdir -p /run/flo

#3. create a group and add flo and blockbook-flo & set permission for dir
# Create a common group (e.g., flo-group)
groupadd flo-group

# Add users to the common group
usermod -aG flo-group flo
usermod -aG flo-group blockbook-flo

# Set the common group ownership on the directory
chown :flo-group /run/flo

# Give the group read-write permissions on the directory
chmod 777 /run/flo

# 4. run main commands as user

su -s /bin/bash -c "/opt/coins/nodes/flo/bin/flod -datadir=/opt/coins/data/flo/backend -conf=/opt/coins/nodes/flo/flo.conf -pid=/run/flo/flo.pid" flo

su -s /bin/bash -c "cd /opt/coins/blockbook/flo && /opt/coins/blockbook/flo/bin/blockbook -blockchaincfg=/opt/coins/blockbook/flo/config/blockchaincfg.json -datadir=/opt/coins/data/flo/blockbook/db -sync -internal=:9066 -public=:9166 -certfile=/opt/coins/blockbook/flo/cert/blockbook -explorer= -log_dir=/opt/coins/blockbook/flo/logs -dbcache=1073741824" blockbook-flo
