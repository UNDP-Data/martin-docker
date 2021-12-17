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
