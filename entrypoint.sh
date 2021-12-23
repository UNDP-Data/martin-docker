#!/bin/sh
# inject the nev variables into the config file using envsubst
config='/etc/martin/config.yaml'
tmp_config='/etc/martin/tmp_config.yaml'
envsubst < $config > $tmp_config
mv $tmp_config $config
martin --config $config