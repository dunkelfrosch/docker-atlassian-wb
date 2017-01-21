#!/usr/bin/env bash
#
# @copyright (c) 2015-2016 dunkelfrosch, patrick.paechnatz@gmail.com,
# @version 1.0.1
#

# activate strict mode for bash
set -e

# set default file permission
umask 177

# some default constants
CFG_DATEFILE=$(date +"%d%m%Y")
CFG_HOSTPATH="/home/dunkelfrosch/backup/docker/df-atls/database"
CFG_MYSQLDUMP_PARAMS="--opt --compress --force --user root"
# take note that you've to create a symbolic link to your dropbox_uploader.sh script for crontab execution!
CFG_DROPBOX_UPLOADER="/usr/local/bin/dropbox-uploader"
CFG_DROPBOX_CONFIG="/root/.dropbox_uploader"

_backup_application_db() {

    CONTAINER_NAME=""
    DB_USER=""
    DB_PASSWORD=""
    DB_NAME=""

    while [[ ${1} ]]; do
        case "${1}" in
            --container-name)
                CONTAINER_NAME="${2}"
                shift
                ;;
            --db-user)
                DB_USER="${2}"
                shift
                ;;
            --db-password)
                DB_PASSWORD="${2}"
                shift
                ;;
            --db-name)
                DB_NAME="${2}"
                shift
                ;;

        esac
        if ! shift; then
            echo "parameter/error 001" "missing parameter argument." >&2
            return 1
        fi
    done

    BKP_FILE="db-$CFG_DATEFILE-$CONTAINER_NAME.sql.gz"
    BKP_FILE_TARGET="$CFG_HOSTPATH/$BKP_FILE"

    echo -e "backup db :: $CONTAINER_NAME -> $BKP_FILE"
    echo -e "          :: - fetch db data and zip result"
    docker exec --user root $CONTAINER_NAME /bin/bash -c "mysqldump ${CFG_MYSQLDUMP_PARAMS} -u$DB_USER -p$DB_PASSWORD $DB_NAME | gzip -9 -c > /tmp/$BKP_FILE" > /dev/null 2>&1
    echo -e "          :: - move file to backup path"
    docker exec --user root $CONTAINER_NAME /bin/bash -c "cat /tmp/$BKP_FILE" > $BKP_FILE_TARGET
    echo -e "          :: - remove temporary files"
    docker exec --user root $CONTAINER_NAME /bin/bash -c "rm -f /tmp/$BKP_FILE"
    echo -e "          :: - copy shadow archive to dropbox.com app target path (/)"
    $CFG_DROPBOX_UPLOADER -q -s -f $CFG_DROPBOX_CONFIG upload $BKP_FILE_TARGET /
    echo -e "          :: \n<finished>\n"
}

# prepare local backup path
mkdir -p ${CFG_HOSTPATH}

# execute backup function call
_backup_application_db --container-name df-atls-confluence-mysql --db-user "root" --db-password "please-change-me" --db-name "confluence"
_backup_application_db --container-name df-atls-jira-mysql       --db-user "root" --db-password "please-change-me" --db-name "jira"
_backup_application_db --container-name df-atls-bitbucket-mysql  --db-user "root" --db-password "please-change-me" --db-name "bitbucket"

# delete files older than 30 days
find ${CFG_HOSTPATH}/* -mtime +30 -exec rm {} \;

