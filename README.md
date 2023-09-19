# Blockbook docker

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