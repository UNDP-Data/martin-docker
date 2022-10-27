# martin-docker

This is a Docker image of martin for UNDP GeoHub. It features a reactive entrypoint, that is
the server can be updated in close to real time for a remote web accessible config file.
An empty basic [config](./config.yaml) file is provided.

## Configuration

martin server can be run in two main modes. 
### 1. without configuration file

In this mode martin will use environmental variable $DATABASE_URL to connect to a PostGIS
database. Inirially this mode could use a variable called $WATCH which made the server reload its internal configuration
in case the value of this was <mark>**true**.</mark> This parameter seems to be now obsolete

The disadvantage of this mode is that martin will once scan the database and all table/fucntions sources will be published

### 2. with configuration file

In this mode the server uses a configuration file that specifies what tables/functions are to be published
By default this is a static setup, which means the server has to be restarted if the config
file was updated.

This limitation was addressed and is handled using a reactive sh [entrypoint script](./reactive_entrypoint.sh)
In this setup, the entrypoint script operates in an infinite loop
and its behavior is controlled by two environmental variables

- `$REMOTE_CFG` - specifies the location of remote config file to be watched
- `$SLEEP_SEC` -  specifies the interval in seconds when the script is going to pull the remote, has a defalt value
of 900 seconds or 15 minutes


configuration file, compare it with its local version and replace  the local with the remote in case
the size of the two config file has changed

Although not very elegant, this setup ensures a smooth operation and minimum work required to
update the user. The config file can be generated automatically using [martin-config](https://github.com/UNDP-Data/martin-config/tree/main/src/martin_config)





## Run using locally build image

```bash
 docker-compose  -f docker-compose-local.yml build
 docker-compose  -f docker-compose-local.yml up
```


## Run using remote image

```bash
 docker-compose up
```
