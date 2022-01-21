# martin-docker

This is a Docker image of martin for geohub

## Build image

Put your `config.yaml` in the same folder of Dockerfile before building.

```bash
$docker build -t ghcr.io/undp-data/martin-docker:main .
```

## Push to Github container registry

```bash
$docker push ghcr.io/undp-data/martin-docker:main
```

## Run martin

- `cp .env.example .env`
- Set `LISTEN_ADDRESSES` and `DATABASE_URL` in `.env`
- Run `docker-compose up`

## Update config.yaml by martin-config package

first of all, create `.env` to configure PostGIS connection string.

```bash
cp .env.example .env

# edit `DATABASE_URL=` variable
```

```bash
# build docker image by docker-compose
$docker-compose -f docker-compose-config-build.yml build --no-cache

# generate config.yaml
$docker-compose -f docker-compose-config-build.yml up
```

if you want to change the target schemes, please edit `docker-compose-config-build.yml` as follows.
