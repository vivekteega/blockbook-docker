# Blockbook docker

## Pre-requisites
Should have [sysbox installed on your machine](https://github.com/nestybox/sysbox/blob/master/docs/developers-guide/build.md)

## Main commands
```
sudo docker run -d --runtime=sysbox-runc -P -p <hostport>:9166 --name blockbook ranchimallfze/blockbook:1.0.0
```

## Requirements

Installation of Sysbox:
```

git clone --recursive https://github.com/nestybox/sysbox.git
make (For this step go to the sysbox directory)
make sysbox-static
sudo make install
make sysbox TARGET_ARCH=arm64
sudo ./docker-cfg --sysbox-runtime=enable (For this step go to the scr directory)
<!--If in step 6 command not found error comes then first install jq and then again run this command.-->

 ```

For Uninstalling:
```

sudo make uninstall
make clean

 ```

Installation of Docker:
```

sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/   
docker-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/
ubuntu focal stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 
<!--Replace focal with your Ubuntu version (e.g., bionic, xenial, or hirsute) if you are using a different version-->
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo docker --version 
<!--If installed correctly the version will be displayed-->

```

## Running Manually

+  After the installation of docker and sysbox run the dockerfile.
   For running first we build its docker-image by the following command:

   ```

   docker build -t <IMG_NAME> .   
   <!--If the directory of the dockerfile and the present directory is same-->
   docker build -f <PATH_TO_DOCKERFILE> -t <IMG_NAME> <DOCKERFILE DIRECTORY> 
   <!--If the directory of the dockerfile and the present directory is not same-->

   ```
        
+  After building the docker-image use the following command to run it.
   ```

   docker run -d --privileged -p <CONTAINER_PORT>:<HOST_PORT> --name <CONTAINER_NAME> <IMG_NAME>
   <!--The container port for our docker file is 9166.-->
   docker run -d --privileged -p 9166:<HOST_PORT> --name <CONTAINER_NAME> <IMG_NAME>

   ```

+  Now access the blockbook by opening the following LINK: https://localhost:<HOST_PORT>/
   Use xdg-open https://localhost:<HOST_PORT>/ to open the link through the terminal and can view the interface of Blockbook.


## Testing  

The code and steps required to run Docker version of Blockbook block explorer

```
sudo docker build -t blockbook-althelper -f Dockerfile-althelper .
sudo docker run -d --privileged -p 9166:9166 d5e56e218acd
```

```
docker buildx create --driver-opt image=moby/buildkit:master --use --name insecure-builder --buildkitd-flags '--allow-insecure-entitlement security.insecure'
docker buildx use insecure-builder
docker buildx build --allow security.insecure ...(other build args)...
sudo docker buildx build --allow security.insecure -t blockbook .
docker buildx rm insecure-builder


sudo docker run -v /var/run/docker.sock:/var/run/docker.sock -ti ubuntu:20.04
```

```
sudo docker run -d --runtime=sysbox-runc -P -p 9167:9166 5018bee64419

sudo docker run -d --runtime=sysbox-runc --net=host -P 5018bee64419
```

 ## Code Explanation

 + We use the base image "nestybox/ubuntu-focal-systemd-docker," which is an Ubuntu-based image with 
   systemd for managing system services.
 + We update the package list and installs necessary packages like wget, gnupg2,software-properties-common, 
   and unzip.
 + The Dockerfile downloads a ZIP archive containing Debian (.deb) files from a GitHub repository and
   extracts them.
 + Within the extracted directory, it installs two Debian packages ("dind_backend-flo_0.15.1.1-satoshilabs 
   -1_amd64.deb" and "dind_blockbook-flo_0.4.0_amd64.deb") using apt .
 + It exposes three ports (22, 80, and 9166) for potential network access.
 + The CMD instruction specifies the default command to run when a container is started based on this 
   image. In this case, it starts the systemd initialization process.


   ## Why Sysbox Is Used ?

 + When you run Docker containers inside a Docker container (DinD), the inner containers typically share    
   the same Docker daemon as the host and other containers. This can lead to security and isolation concerns.
 + Sysbox allows you to run containers within an isolated environment, providing stronger separation 
   between inner containers, the host, and other outer containers. This is achieved by creating separate container runtimes for each inner container using runc (the OCI runtime).      
 + In our dockerfile we are able to execute systemctl command by using sysbox.
