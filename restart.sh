#!/usr/bin/env bash
#
# @copyright (c) 2015 dunkelfrosch, patrick.paechnatz@gmail.com,
# @version 1.0.0
#

set -e

# service docker restart
# START JIRA BASE CONTAINER PROCESSOR
docker-compose --file ./df-atls-jira/compose.yml restart jira
# START BITBUCKET BASE CONTAINER PROCESSOR
docker-compose --file ./df-atls-bitbucket/compose.yml restart bitbucket
# START CONFLUENCE BASE CONTAINER PROCESSOR
docker-compose --file ./df-atls-confluence/compose.yml restart confluence
# START PROXY BASE CONTAINER PROCESSOR
docker-compose --file ./df-atls-nginx-proxy/compose.yml restart nginx