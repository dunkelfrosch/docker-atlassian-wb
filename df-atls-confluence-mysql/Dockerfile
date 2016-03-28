#
# BUILD    : DF/[ATLASSIAN][CONFLUENCE][MYSQL]
# OS/CORE  : debian:8
# SERVICES : mysql 5.7.n
#
# VERSION 1.0.1
#

FROM mysql:5.7

MAINTAINER Patrick Paechnatz <patrick.paechnatz@gmail.com>
LABEL com.container.vendor="dunkelfrosch impersonate" \
      com.container.service="atlassian/confluence/mysql" \
      com.container.priority="1" \
      com.container.project="workbench/atlassian" \
      img.version="1.0.1" \
      img.description="our main confluence atlassian mysql container"

# prepare main remote docker helper script path + additions
RUN mkdir -p /opt/docker \
             /etc/mysql/conf.d

# copy docker script debian cleanup file to docker image
ADD https://raw.githubusercontent.com/dunkelfrosch/docker-bash/master/docker_cleanup_debian.sh /opt/docker/

# x-layer 1: package manager related processor
RUN set -e \
    && apt-get update -qq >/dev/null 2>&1 \
    && apt-get install -qq -y --no-install-recommends mc ntp sysstat >/dev/null 2>&1

# x-layer 2: system core setup related processor
RUN set -e \
    && echo "${TIMEZONE}" >/etc/timezone \
    && dpkg-reconfigure tzdata >/dev/null 2>&1

# x-layer 3: application base setup related processor
RUN { \
      echo '[mysqld]'; \
      echo 'character-set-server=utf8'; \
      echo 'collation-server=utf8_bin'; \
      echo 'innodb_log_file_size=256M'; \
      echo 'innodb_buffer_pool_size=64M'; \
      echo 'max_allowed_packet=48M'; \
      echo '[client]'; \
      echo 'default-character-set=utf8'; \
    } > /etc/mysql/conf.d/charset.cnf

# x-layer 4: build script cleanup related processor
RUN set -e \
    && sh /opt/docker/docker_cleanup_debian.sh

VOLUME ["/var/lib/mysql"]
