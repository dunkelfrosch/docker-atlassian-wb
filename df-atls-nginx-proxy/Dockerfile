#
# BUILD    : DF/[ATLASSIAN][PROXY][NGINX]
# OS/CORE  : debian:8
# SERVICES : nginx 1.9.7
#
# VERSION 1.0.0
#

FROM nginx:1.9.7

MAINTAINER Patrick Paechnatz <patrick.paechnatz@gmail.com>
LABEL com.container.vendor="dunkelfrosch impersonate" \
      com.container.service="atlassian/proxy/nginx" \
      com.container.priority="1" \
      com.container.project="atlassian" \
      img.version="1.0.0" \
      img.description="our main atlassian nginx proxy container"

ENV TERM xterm
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV TIMEZONE "Europe/Berlin"

# Setup additional application config environment variables
ENV CFG_NGINX_FQN_HOSTNAME     "dunkelfrosch.com"
ENV CFG_NGINX_URI_JIRA         "/go/to/jira"
ENV CFG_NGINX_URI_CONFLUENCE   "/go/to/confluence"
ENV CFG_NGINX_URI_BITBUCKET    "/go/to/bitbucket"

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
ADD /opt/docker/* /opt/docker/

# x-layer 1: package manager related processor
RUN apt-get update -qq >/dev/null 2>&1 \
    && apt-get install -qq -y --no-install-recommends mc wget curl ntp ca-certificates >/dev/null 2>&1

# x-layer 2: create selfsigned ssl certificate using defined fqdn and set auto-trust
RUN openssl req -new -newkey rsa:4096 -sha256 -days 1095 -nodes -x509 -subj "/C=DE/ST=STATE/L=CITY/O=MAIL/CN=${CFG_NGINX_FQN_HOSTNAME}" -keyout /etc/ssl/${CFG_NGINX_FQN_HOSTNAME}.key  -out /etc/ssl/${CFG_NGINX_FQN_HOSTNAME}.cer \
    && chmod 600 /etc/ssl/${CFG_NGINX_FQN_HOSTNAME}.key \
    && cp /etc/ssl/${CFG_NGINX_FQN_HOSTNAME}.cer /usr/local/share/ca-certificates/ \
    && update-ca-certificates

# x-layer 3: application base setup related processor
RUN rm -f /etc/nginx/nginx.conf \
    && rm -f /etc/nginx/conf.d/default.conf \
    && mv /opt/docker/nginx.conf /etc/nginx/nginx.conf \

    && mv /opt/docker/default.conf /etc/nginx/sites-available/default.conf \
    && sed -i "s|%fqn_hostname%|$CFG_NGINX_FQN_HOSTNAME|g" /etc/nginx/sites-available/default.conf \
    && sed -i "s|%target_url_jira%|$CFG_NGINX_URI_JIRA|g" /etc/nginx/sites-available/default.conf \
    && sed -i "s|%target_url_confluence%|$CFG_NGINX_URI_CONFLUENCE|g" /etc/nginx/sites-available/default.conf \
    && sed -i "s|%target_url_bitbucket%|$CFG_NGINX_URI_BITBUCKET|g" /etc/nginx/sites-available/default.conf \
    && sed -i "s|%ssl_cert_file%|/etc/ssl/$CFG_NGINX_FQN_HOSTNAME.cer|g" /etc/nginx/sites-available/default.conf \
    && sed -i "s|%ssl_key_file%|/etc/ssl/$CFG_NGINX_FQN_HOSTNAME.key|g" /etc/nginx/sites-available/default.conf \
    && ln -sf /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/df-default \

    && chown nginx: /var/www -R \
    && echo "${TIMEZONE}" >/etc/timezone \
    && dpkg-reconfigure tzdata >/dev/null 2>&1

# x-layer 4: build script cleanup related processor
RUN set -e \
    && sh /opt/docker/cleanup.sh

EXPOSE 80 443
