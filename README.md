# Blockbook docker


## Video-Demonstration For Mainnet
+ https://drive.google.com/file/d/1MQlndJi1w992uhUtGTbf89uq0Q7mZR6k/view?usp=sharing (Only Text)
+ https://www.youtube.com/watch?v=QKd3EriMPx0 (Both Text And Audio)

## Video-Demonstration For Testnet
+ https://youtu.be/EnX3-cBbpcE (Both Text And Audio)

## Pre-requisites
Should have [sysbox installed on your machine](https://github.com/nestybox/sysbox/blob/master/docs/developers-guide/build.md)

## Main commands (For Both Mainnet and Testnet)
```
sudo docker run -d --runtime=sysbox-runc -P -p <hostport>:9166 --name blockbook ranchimallfze/blockbook:1.0.0
```

## Requirements

### Installation of Sysbox:
```

git clone --recursive https://github.com/nestybox/sysbox.git
make (For this step go to the sysbox directory)
make sysbox-static
sudo make install
make sysbox TARGET_ARCH=arm64
sudo ./docker-cfg --sysbox-runtime=enable (For this step go to the scr directory)
<!--If in step 6 command not found error comes then first install jq and then again run this command.-->

 ```

### For Uninstalling:
```

sudo make uninstall
make clean

 ```

### Installation of Docker:
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

## How to see available ports ?

+  Open a new terminal on your Ubuntu system and copy the code given below:
``` 

  # Specify the range of ports you want to check (e.g., 8000 to 9000)
  start_port=8000
  end_port=9000

  # Use a loop to check each port in the specified range
  for port in $(seq "$start_port" "$end_port"); do
    # Use netstat or ss to check if the port is in use
    if ! ss -tuln | grep -q ":$port\b"; then
      echo "Port $port is available"
    fi
  done

  ```



## Running Manually For Both Mainnet And Testnet

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

   docker run -d --privileged -p <HOST_PORT>:<CONTAINER_PORT> --name <CONTAINER_NAME> <IMG_NAME>
   <!--The container port for our docker file is 9166.-->
   docker run -d --privileged -p <HOST_PORT>:9166 --name <CONTAINER_NAME> <IMG_NAME>

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

 ## Code Explanation For Mainnet

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


 ## Code Explanation For Testnet

  + This line specifies the base image for the Docker container. It starts with a base image called nestybox/ubuntu-focal-systemd-docker, 
    which includes Ubuntu Focal Fossa (20.04) with systemd support.
  + We run a shell command inside the container during the image-building process. It updates the package list by executing apt 
    update. The && operator is used to chain multiple commands in a single line.
  + We define an argument named TESTNET with a default value of false. Docker ARGs can be used to pass values at build time, and 
    in this case, it's determining whether to set up the testnet or the mainnet environment.
  + Inside the if block, this line downloads a ZIP file containing testnet-related files from a GitHub repository using wget and 
    then unzips it using unzip.
  + If the value of TESTNET is not "true," the else block is executed.Inside the else block, similar to the if block, we download
    a different ZIP file (likely containing mainnet-related files) and unzip it.
  + We change the working directory to the one where the mainnet ZIP file was extracted (blockbook-docker-main) and install the 
    same two Debian packages as in the if block.
  + Use of 'fi' marks the end of the conditional statement, closing the if-else block.
  + Now we expose the ports 22, 80, and 9166 and make them accessible for communication with the host system or other containers.
  + The CMD instruction specifies the default command to run when a container is started based on this 
    image. In this case, it starts the systemd initialization process.



   ## Why Sysbox Is Used ?

 + When you run Docker containers inside a Docker container (DinD), the inner containers typically share    
   the same Docker daemon as the host and other containers. This can lead to security and isolation concerns.
 + Sysbox allows you to run containers within an isolated environment, providing stronger separation 
   between inner containers, the host, and other outer containers. This is achieved by creating separate container runtimes for each inner container using runc (the OCI runtime).      
 + In our dockerfile we are able to execute systemctl command by using sysbox.
