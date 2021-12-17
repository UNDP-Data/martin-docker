#!/bin/sh

set -e

config='/etc/martin/config.yaml'
sed -i '/^connection_string:.*/d' $config
sed -i '/^listen_addresses:.*/d' $config
echo connection_string: $DATABASE_URL >> $config
echo listen_addresses: "$LISTEN_ADDRESSES" >> $config

martin --config /etc/martin/config.yaml