#
# BUILD    : DF/[ATLASSIAN][PROXY][NGINX]
# OS/CORE  : debian:8
# SERVICES : nginx 1.9.9
#
# VERSION 1.0.1
#

FROM nginx:1.9.9

MAINTAINER Patrick Paechnatz <patrick.paechnatz@gmail.com>
LABEL com.container.vendor="dunkelfrosch impersonate" \
      com.container.service="atlassian/proxy/nginx" \
      com.container.priority="1" \
      com.container.project="workbench/atlassian" \
      img.version="1.0.1" \
      img.description="our main atlassian nginx proxy container"

ARG NGINX_URI_JIRA
ARG NGINX_URI_CONFLUENCE
ARG NGINX_URI_BITBUCKET
ARG NGINX_DOMAIN_PUBLIC

# prepare main remote docker helper script path
RUN mkdir -p /etc/nginx/sites-available \
             /etc/nginx/sites-enabled \
             /etc/nginx/ssl \
             /var/www/df-landing \
             /opt/docker

# copy some major config and script files to docker image
ADD /etc/nginx/nginx.conf /opt/docker/nginx.conf
ADD /etc/nginx/sites-available/default.conf /opt/docker/default.conf
ADD /var/www/df-landing /var/www/df-landing/

# copy docker script debian cleanup file to docker image
ADD https://raw.githubusercontent.com/dunkelfrosch/docker-bash/master/docker_cleanup_debian.sh /opt/docker/

# x-layer 1: package manager related processor
RUN apt-get update -qq >/dev/null 2>&1 \
    && apt-get install -qq -y --no-install-recommends mc wget curl ntp ca-certificates >/dev/null 2>&1

# x-layer 2: create selfsigned ssl certificate using defined fqdn and set auto-trust
RUN openssl req -new -newkey rsa:4096 -sha256 -days 1095 -nodes -x509 -subj "/C=DE/ST=STATE/L=CITY/O=MAIL/CN=${NGINX_DOMAIN_PUBLIC}" -keyout /etc/ssl/${NGINX_DOMAIN_PUBLIC}.key  -out /etc/ssl/${NGINX_DOMAIN_PUBLIC}.cer \
    && chmod 600 /etc/ssl/${NGINX_DOMAIN_PUBLIC}.key \
    && cp /etc/ssl/${NGINX_DOMAIN_PUBLIC}.cer /usr/local/share/ca-certificates/ \
    && update-ca-certificates

# x-layer 3: application base setup related processor
RUN rm -f /etc/nginx/nginx.conf \
    && rm -f /etc/nginx/conf.d/default.conf \
    && mv /opt/docker/nginx.conf /etc/nginx/nginx.conf \

    && mv /opt/docker/default.conf /etc/nginx/sites-available/default.conf \
    && sed -i "s|%fqn_hostname%|$NGINX_DOMAIN_PUBLIC|g" /etc/nginx/sites-available/default.conf \
    && sed -i "s|%target_url_jira%|$NGINX_URI_JIRA|g" /etc/nginx/sites-available/default.conf \
    && sed -i "s|%target_url_confluence%|$NGINX_URI_CONFLUENCE|g" /etc/nginx/sites-available/default.conf \
    && sed -i "s|%target_url_bitbucket%|$NGINX_URI_BITBUCKET|g" /etc/nginx/sites-available/default.conf \
    && sed -i "s|%ssl_cert_file%|/etc/ssl/$NGINX_DOMAIN_PUBLIC.cer|g" /etc/nginx/sites-available/default.conf \
    && sed -i "s|%ssl_key_file%|/etc/ssl/$NGINX_DOMAIN_PUBLIC.key|g" /etc/nginx/sites-available/default.conf \
    && ln -sf /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/df-default \

    && chown nginx: /var/www -R \
    && echo "${TIMEZONE}" >/etc/timezone \
    && dpkg-reconfigure tzdata >/dev/null 2>&1

# x-layer 4: build script cleanup related processor
RUN set -e \
    && sh /opt/docker/docker_cleanup_debian.sh

EXPOSE 80 443
