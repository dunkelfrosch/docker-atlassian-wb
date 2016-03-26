#!/usr/bin/env bash
#
# configuration value script for our workbench, usage: eval $(./wb_config.sh)
#
# @copyright (c) 2015-2016 dunkelfrosch, patrick.paechnatz@gmail.com,
# @version 1.0.0
#

echo export CFG_DOMAIN_INTERNAL="df.atlassian.workbench"
echo export CFG_DOMAIN_PUBLIC="dunkelfrosch.com"
echo export CFG_DOMAIN_PUBLIC_PROTOCOL="https"
echo export CFG_DOMAIN_PUBLIC_PORT=443
echo export CFG_URI_JIRA="/go/to/jira"
echo export CFG_URI_CONFLUENCE="/go/to/confluence"
echo export CFG_URI_BITBUCKET="/go/to/bitbucket"
