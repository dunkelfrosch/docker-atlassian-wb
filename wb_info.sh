#!/usr/bin/env bash
#
# info script for running workbench services
#
# @copyright (c) 2015-2016 dunkelfrosch, patrick.paechnatz@gmail.com,
# @version 1.0.0
#

set -e

DBG_NGINX_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' df-atls-nginx-proxy)
DBG_JIRA_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' df-atls-jira-app)
DBG_CONFLUENCE_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' df-atls-confluence-app)
DBG_BITBUCKET_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' df-atls-bitbucket-app)
DBG_NGINX_RUNNING=$(docker inspect --format '{{ .State.Running }}' df-atls-nginx-proxy)

docker stats