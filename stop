#!/usr/bin/env bash
#
# @copyright (c) 2015 dunkelfrosch, patrick.paechnatz@gmail.com,
# @version 1.0.0
#

set -e

# STOP PROXY BASE CONTAINER PROCESSOR
docker-compose --file ./df-atls-nginx-proxy/compose.yml stop nginx
# STOP JIRA BASE CONTAINER PROCESSOR
docker-compose --file ./df-atls-jira/compose.yml stop jira jira_mysql
# STOP BITBUCKET BASE CONTAINER PROCESSOR
docker-compose --file ./df-atls-bitbucket/compose.yml stop bitbucket bitbucket_mysql
# STOP CONFLUENCE BASE CONTAINER PROCESSOR
docker-compose --file ./df-atls-confluence/compose.yml stop confluence confluence_mysql
