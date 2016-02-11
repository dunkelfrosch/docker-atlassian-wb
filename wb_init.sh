#!/usr/bin/env bash
#
# @copyright (c) 2015-2016 dunkelfrosch, patrick.paechnatz@gmail.com,
# @version 1.0.0
#

set -e

# *** bootUp for version < 1.6.n o docker-compose
docker-compose --x-networking --x-network-driver=bridge up -d

# *** bootUp for version >= 1.6.n of docker-compose
# docker-compose --file docker-composer-v2.yml up -d
