#
# BUILD    : DF/[ATLASSIAN][CONFLUENCE]
# OS/CORE  : java:8
# SERVICES : -
#
# VERSION 1.0.0
#

FROM dunkelfrosch/confluence:5.9.3

MAINTAINER Patrick Paechnatz <patrick.paechnatz@gmail.com>
LABEL com.container.vendor="dunkelfrosch impersonate" \
      com.container.service="atlassian/confluence" \
      com.container.priority="1" \
      com.container.project="workbench/atlassian" \
      img.version="1.0.0" \
      img.description="our confluence atlassian workbench container"

# Setup application install environment variables
ENV CONFLUENCE_HOME         "/var/atlassian/confluence"
ENV CONFLUENCE_INSTALL      "/opt/atlassian/confluence"
ENV _RUNJAVA                "/usr/bin/java"

# Setup additional application config environment variables
ENV CFG_TARGET_URI          "/go/to/confluence"
ENV CFG_PROXY_HOST          "dunkelfrosch.com"
ENV CFG_PROXY_SCHEME        "https"
ENV CFG_PROXY_PORT          443

# Use the default unprivileged account. This could be considered bad practice
# on systems where multiple processes end up being executed by 'daemon' but
# here we only ever run one process anyway.
ENV RUN_USER  daemon
ENV RUN_GROUP daemon

# using root user for all upcomming installation/setup steps below
USER root

# copy some major config and script files to docker image
ADD /opt/atlassian/confluence/conf/server.xml /tmp/server.xml

# x-layer 1: advanced application setup related processor
RUN cp -f /tmp/server.xml ${CONFLUENCE_INSTALL}/conf/server.xml \
    && chown ${RUN_USER}:${RUN_GROUP} ${CONFLUENCE_INSTALL}/conf/server.xml \
    && rm -f /tmp/server.xml \
    && xmlstarlet ed --inplace \
        -u '//Server/Service/Engine/Host/Context[@path="_path_"]/@path' -v "${CFG_TARGET_URI}" \
        -u '//Server/Service/Connector[@proxyName="_proxyName_"]/@proxyName' -v "${CFG_PROXY_HOST}" \
        -u '//Server/Service/Connector[@scheme="_scheme_"]/@scheme' -v "${CFG_PROXY_SCHEME}" \
        -u '//Server/Service/Connector[@proxyPort="_proxyPort_"]/@proxyPort' -v "${CFG_PROXY_PORT}" \
        "${CONFLUENCE_INSTALL}/conf/server.xml" \

    && chmod -R 700 ${CONFLUENCE_HOME} ${CONFLUENCE_INSTALL} \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${CONFLUENCE_HOME} ${CONFLUENCE_INSTALL}

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory (accessing logs). These directories will be set-and-used during
# data-only container volume bound run-mode.
VOLUME ["${CONFLUENCE_INSTALL}", "${CONFLUENCE_HOME}"]

# Reset base container execution user/group (no root-right container allowed here)
# using the default unprivileged account.
USER ${RUN_USER}:${RUN_GROUP}

# Run Atlassian Confluence as a foreground process by default.
CMD ["/opt/atlassian/confluence/bin/start-confluence.sh", "-fg"]
