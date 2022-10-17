#!/bin/bash

if [ -f .env ]; then
    # Load Environment Variables
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')

fi



#if [ -z "$DATABASE_URL" ]
if [ -z "$DATABASE_URL" ] && [ -z ${DATABASE_URL} ]
then
  echo "DATABASE_URL is not set. The vector tile server can not connect to PostGIS server."
  exit 1
fi



# inject the env variables into the config file using envsubst
CONFIG="./config.yaml"
#extract the vakue from config
DBURL=$(grep -R "\$DATABASE_URL" $CONFIG |  awk '/:/ {print $2}')

#if grep -Fq "\$DATABASE_URL" $CONFIG
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
