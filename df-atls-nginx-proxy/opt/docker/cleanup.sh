#!/usr/bin/env bash
#
# run only in docker container environment
#
if [ -f /.dockerinit ]; then
    apt-get clean autoclean >/dev/null 2>&1 && \
    apt-get autoremove -y >/dev/null 2>&1
    rm -rf /var/lib/cache /var/lib/log /tmp/* /var/tmp/*
    rm -f  /etc/dpkg/dpkg.cfg.d/02apt-speedup \
           /etc/cron.daily/standard \
           /etc/cron.daily/upstart \
           /etc/cron.daily/dpkg \
           /etc/cron.daily/password \
           /etc/cron.weekly/fstrim && \
    echo '' > /var/log/dpkg.log && \
    echo '' > /var/log/faillog && \
    echo '' > /var/log/lastlog && \
    echo '' > /var/log/bootstrap.log && \
    echo '' > /var/log/alternatives.log && \
    rm -f /opt/docker/*

else
    echo -e "\033[0;31m this script is only be run in container environment <EXIT>!\033[0m";
    exit 127
fi
