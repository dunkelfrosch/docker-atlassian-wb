#!/usr/bin/env bash
#
# @copyright (c) 2015-2016 dunkelfrosch, patrick.paechnatz@gmail.com,
# @version 1.0.0
#

set -e

# stop all running workbench container firstly
./stop.sh

# service docker restart

# BUILD JIRA BASE CONTAINER PROCESSOR
# - (re)build jira mysql and application container base
docker-compose --file ./df-atls-jira/compose.yml rebuild jira

# BUILD BITBUCKET BASE CONTAINER PROCESSOR
# - (re)build bitbucket mysql and application container base
docker-compose --file ./df-atls-bitbucket/compose.yml rebuild bitbucket

# BUILD CONFLUENCE BASE CONTAINER PROCESSOR
# - (re)build jira mysql and application container base
docker-compose --file ./df-atls-confluence/compose.yml rebuild confluence

# BUILD PROXY BASE CONTAINER PROCESSOR
# - (re)build jira mysql and application container base
docker-compose --file ./df-atls-nginx-proxy/compose.yml rebuild nginx