# Blockbook docker

## Roadmap for upgrade

- [ ] How to set this up in production
- [ ] Think of how Blockbook container will detect the status of backend container
- [ ] Figure out if multiple volume path need to be mounted
- [ ] See if creating a new network for both the containers will be a good option.
- [X] [Unable to build frontend separately since having backend package installed is a dependency] Create separate images for both backend and blockbook.
- [X] Attach the same volume to both the running containers of the images.

## Quickstart

To run the services using this file create a .env file using .env.example file, fill info and run the following command in the same directory:

```
sudo docker-compose up -d
```

## Running blockbook manually

```

docker volume create blockbook

docker network create blockbook

# Run backend in "it" mode for testing
docker run -it --name blockbook-backend --mount source=blockbook,target=/opt -p 38366:38366 -p 8066:8066 --network=blockbook vivekteega/blockbook:1.0.0 backend

# Run backend in daemon mode for production
docker run -d --name blockbook-backend --mount source=blockbook,target=/opt -p 38366:38366 -p 8066:8066 --network=blockbook vivekteega/blockbook:1.0.0 backend

# Run backend in daemon mode for production with Bootstrap
docker run -d --name blockbook-backend --mount source=blockbook,target=/opt -p 38366:38366 -p 8066:8066 --network=blockbook --env BOOTSTRAP_URL=https://bootstrap.ranchimall.net/blockbook-flo-backend1.tar.gz vivekteega/blockbook:1.0.0 backend


# Run frontend in "it" mode for testing
docker run -it --name blockbook-frontend --mount source=blockbook,target=/opt -p 9166:9166 -p 9066:9066 --network=blockbook vivekteega/blockbook:1.0.0 frontend 172.20.0.2

# Run frontend in daemon mode for production
docker run -d --name blockbook-frontend --mount source=blockbook,target=/opt -p 9166:9166 -p 9066:9066 --network=blockbook vivekteega/blockbook:1.0.0 frontend 172.20.0.2

# Bootstrap
docker run -d --name blockbook-frontend --mount source=blockbook,target=/opt -p 9166:9166 -p 9066:9066 --network=blockbook --env BOOTSTRAP_URL=https://bootstrap.ranchimall.net/blockbook-flo-frontend.tar.gz vivekteega/blockbook:1.0.0 frontend 172.20.0.2

```
