#!/usr/bin/env bash
#
# check environment: exit if you're not inside a valid container environment - otherwise cleanup build cache
#
if [ -f /.dockerinit ]; then
    #
    # clear image/os cache
    #
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
    echo '' > /var/log/alternatives.log

    #
    # remove docker cache files / helper scripts from container
    #
    rm -f /opt/docker/*

else
    echo -e "\033[0;31m this script will only be executable inside container environment <aborted>!\033[0m";
    exit 127
fi

exit 0