#!/bin/bash


# exit with error code 1 if the env variable DATABASE_URL is not set or empty

if [ -z "$DATABASE_URL" ] && [ -z ${DATABASE_URL} ]
then
  echo "DATABASE_URL is not set. The vector tile server can not connect to PostGIS server."
  exit 1
fi



# inject the env variables into the config file using envsubst
CONFIG="/etc/martin/config.yaml"

#extract the value from config.yaml
DBURL=$(grep -R "\$DATABASE_URL" $CONFIG |  awk '/:/ {print $2}')

#if it is not set
if [ "$DBURL" = "'\$DATABASE_URL'" ]
then
    echo "Interpolating env vars into $CONFIG ..."
    TMP_CONFIG="./tmp_config.yaml"
    envsubst < $CONFIG > $TMP_CONFIG
    cat $TMP_CONFIG > $CONFIG
    rm -rf $TMP_CONFIG
else
    echo "$CONFIG is already interpolated and will be reused ..."
fi

#run the server using the config
martin --config $CONFIG