# Blockbook docker

The code and steps required to run Docker version of Blockbook block explorer

```
sudo docker build -t blockbook-althelper -f Dockerfile-althelper .
sudo docker run -d --privileged -p 9166:9166 d5e56e218acd
```