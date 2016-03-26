#
# BUILD    : DF/[ATLASSIAN][JIRA]
# OS/CORE  : java:8
# SERVICES : -
#
# VERSION 1.0.1
#

FROM dunkelfrosch/jira:7.0.5

MAINTAINER Patrick Paechnatz <patrick.paechnatz@gmail.com>
LABEL com.container.vendor="dunkelfrosch impersonate" \
      com.container.service="atlassian/jira" \
      com.container.priority="1" \
      com.container.project="workbench/atlassian" \
      img.version="1.0.1" \
      img.description="our jira atlassian workbench container"

# Setup parametric build arguments
ARG CFG_TARGET_URI
ARG CFG_PROXY_HOST
ARG CFG_PROXY_SCHEME
ARG CFG_PROXY_PORT

# Setup application install environment variables
ENV JIRA_HOME               "/var/atlassian/jira"
ENV JIRA_INSTALL            "/opt/atlassian/jira"
ENV _RUNJAVA                "/usr/bin/java"

# Use the default unprivileged account. This could be considered bad practice
# on systems where multiple processes end up being executed by 'daemon' but
# here we only ever run one process anyway.
ENV RUN_USER  daemon
ENV RUN_GROUP daemon

# using root user for all upcomming installation/setup steps below
USER root

# copy some major config and script files to docker image
ADD /opt/atlassian/jira/conf/server.xml /tmp/server.xml

# x-layer 1: advanced application setup related processor
RUN cp -f /tmp/server.xml ${JIRA_INSTALL}/conf/server.xml \
    && chown ${RUN_USER}:${RUN_GROUP} ${JIRA_INSTALL}/conf/server.xml \
    && rm -f /tmp/server.xml \
    && xmlstarlet ed --inplace \
        -u '//Server/Service/Engine/Host/Context[@path="_path_"]/@path' -v "${CFG_TARGET_URI}" \
        -u '//Server/Service/Connector[@proxyName="_proxyName_"]/@proxyName' -v "${CFG_PROXY_HOST}" \
        -u '//Server/Service/Connector[@scheme="_scheme_"]/@scheme' -v "${CFG_PROXY_SCHEME}" \
        -u '//Server/Service/Connector[@proxyPort="_proxyPort_"]/@proxyPort' -v "${CFG_PROXY_PORT}" \
        "${JIRA_INSTALL}/conf/server.xml" \

    && chmod -R 700 ${JIRA_HOME} ${JIRA_INSTALL} \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${JIRA_HOME} ${JIRA_INSTALL}

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory (accessing logs). These directories will be set-and-used during
# data-only container volume bound run-mode.
VOLUME ["${JIRA_INSTALL}", "${JIRA_HOME}"]

# Reset base container execution user/group (no root-right container allowed here)
# using the default unprivileged account.
USER ${RUN_USER}:${RUN_GROUP}

# Run Atlassian JIRA as a foreground process by default.
CMD ["/opt/atlassian/jira/bin/start-jira.sh", "-fg"]