#!/bin/sh
set -e
# inject the env variables into the config file using envsubst
CONFIG="/etc/martin/config.yaml"

if grep -Fq "\$DATABASE_URL" $CONFIG
then
    TMP_CONFIG="/etc/martin/tmp_config.yaml"
    envsubst < $CONFIG > $TMP_CONFIG
    cat $TMP_CONFIG > $CONFIG
    rm -rf $TMP_CONFIG
fi

martin --config $CONFIG
