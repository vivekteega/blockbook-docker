# Blockbook docker

## Roadmap for upgrade

-  [X] [Unable to build frontend separately since having backend package installed is a dependency] Create separate images for both backend and blockbook.
-  [X] Attach the same volume to both the running containers of the images.
-  [ ] Think of how Blockbook container will detect the spots of backend container
-  [ ] Figure out if multiple volume path need to be mounted
-  [ ] See if creating a new network for both the containers will be a good option. 

## Building and running blockbook image

```
docker build -f Dockerfile -t vivekteega/blockbook:1.0.0 .

docker volume create blockbook

# Run backend in "it" mode
docker run -it --mount source=blockbook,target=/opt -p 38366:38366 -p 8066:8066 vivekteega/blockbook:1.0.0 backend

# Run backend in daemon mode
docker run -d --mount source=blockbook,target=/ -p 38366:38366 -p 8066:8066 vivekteega/blockbook:1.0.0 backend

# Run frontend in "it" mode
docker run -it --mount source=blockbook,target=/opt -p 9166:9166 -p 9066:9066 vivekteega/blockbook:1.0.0 frontend

# Run frontend in it mode
docker run -d --mount source=blockbook,target=/ -p 9166:9166 -p 9066:9066 vivekteega/blockbook:1.0.0 frontend
```

## Building & running backend image

```
docker build -t vivekteega/blockbook-backend:1.0.0 -f Dockerfile_backend .

docker volume create blockbook

docker run -it --mount source=blockbook,target=/opt/coins -p vivekteega/blockbook-backend:1.0.

docker run -d --mount source=blockbook,target=/opt/coins -p 38366:38366 -p 8066:8066 vivekteega/blockbook-backend:1.0.0
```

## Building & running frontend image

```
docker build -t vivekteega/blockbook-frontend:1.0.0 -f Dockerfile_frontend .

docker run -it --mount source=blockbook,target=/opt/coins -p 9166:9166 -p 9066:9066 vivekteega/blockbook-frontend:1.0.0

docker run -d --mount source=blockbook,target=/opt/coins -p 9166:9166 -p 9066:9066 vivekteega/blockbook-frontend:1.0.0
```
