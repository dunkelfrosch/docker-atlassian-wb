#!/usr/bin/env bash
#
# @copyright (c) 2015 dunkelfrosch, patrick.paechnatz@gmail.com,
# @version 1.0.0
#

set -e

# START JIRA BASE CONTAINER PROCESSOR
docker-compose --file ./df-atls-jira/compose.yml up -d jira
# START BITBUCKET BASE CONTAINER PROCESSOR
docker-compose --file ./df-atls-bitbucket/compose.yml up -d bitbucket
# START CONFLUENCE BASE CONTAINER PROCESSOR
docker-compose --file ./df-atls-confluence/compose.yml up -d confluence
# START PROXY BASE CONTAINER PROCESSOR
docker-compose --file ./df-atls-nginx-proxy/compose.yml up -d nginx
