#!/usr/bin/env bash
#
# @copyright (c) 2015-2016 dunkelfrosch, patrick.paechnatz@gmail.com,
# @version 1.0.0
#

set -e

docker-compose --x-networking --x-network-driver=bridge up -d