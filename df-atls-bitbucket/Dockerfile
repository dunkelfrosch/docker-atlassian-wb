#
# BUILD    : DF/[ATLASSIAN][BITBUCKET]
# OS/CORE  : java:8
# SERVICES : -
#
# VERSION 1.0.0
#

FROM dunkelfrosch/bitbucket:4.1.0

MAINTAINER Patrick Paechnatz <patrick.paechnatz@gmail.com>
LABEL com.container.vendor="dunkelfrosch inc." \
      com.container.service="atlassian/bitbucket" \
      com.container.priority="1" \
      com.container.project="workbench/atlassian" \
      img.version="1.0.0" \
      img.description="our confluence atlassian workbench container"

# Setup application install environment variables
ENV BITBUCKET_HOME          /var/atlassian/application-data/bitbucket
ENV BITBUCKET_INSTALL_DIR   /opt/atlassian/bitbucket
ENV _RUNJAVA                "/usr/bin/java"

# Setup additional application config environment variables
ENV CFG_TARGET_URI          "/go/to/bitbucket"
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
ADD /opt/atlassian/bitbucket/conf/server.xml /tmp/server.xml

# x-layer 1: application server setup related processor
RUN cp -f /tmp/server.xml ${BITBUCKET_INSTALL_DIR}/conf/server.xml \
    && chown ${RUN_USER}:${RUN_GROUP} ${BITBUCKET_INSTALL_DIR}/conf/server.xml \
    && rm -f /tmp/server.xml \
    && xmlstarlet ed --inplace \
        -u '//Server/Service/Engine/Host/Context[@path="_path_"]/@path' -v "${CFG_TARGET_URI}" \
        -u '//Server/Service/Connector[@proxyName="_proxyName_"]/@proxyName' -v "${CFG_PROXY_HOST}" \
        -u '//Server/Service/Connector[@scheme="_scheme_"]/@scheme' -v "${CFG_PROXY_SCHEME}" \
        -u '//Server/Service/Connector[@proxyPort="_proxyPort_"]/@proxyPort' -v "${CFG_PROXY_PORT}" \
        "${BITBUCKET_INSTALL_DIR}/conf/server.xml" \

    && chmod -R 700 ${BITBUCKET_HOME} ${BITBUCKET_INSTALL_DIR} \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${BITBUCKET_HOME} ${BITBUCKET_INSTALL_DIR}

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory (accessing logs). These directories will be set-and-used during
# data-only container volume bound run-mode.
VOLUME ["${BITBUCKET_INSTALL_DIR}", "${BITBUCKET_HOME}"]

# Reset base container execution user/group (no root-right container allowed here)
# using the default unprivileged account.
USER ${RUN_USER}:${RUN_GROUP}

# Set entrypoint script for application, bitbucket will run as foreground process (-fg)
CMD ["./bin/start-bitbucket.sh", "-fg"]