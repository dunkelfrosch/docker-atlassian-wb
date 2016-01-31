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
CFG_HOSTPATH="/home/dunkelfrosch/backup/docker/df-atls/files"
# take note that you've to create a symbolic link to your dropbox_uploader.sh script for crontab execution!
CFG_DROPBOX_UPLOADER="/usr/local/bin/dropbox-uploader"
CFG_DROPBOX_CONFIG="/root/.dropbox_uploader"

_backup_application_files() {

    CONTAINER_NAME=""
    DOCKER_SRC_PATH=""
    RANDOM_KEY="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)"

    while [[ ${1} ]]; do
        case "${1}" in
            --container-name)
                CONTAINER_NAME="${2}"
                shift
                ;;
            --docker-src-path)
                DOCKER_SRC_PATH="${2}"
                shift
                ;;

        esac
        if ! shift; then
            echo "parameter/error 001" "missing parameter argument." >&2
            return 1
        fi
    done

    BKP_FILE="files-$CFG_DATEFILE-$CONTAINER_NAME.$RANDOM_KEY.data.gz"
    BKP_FILE_TARGET="$CFG_HOSTPATH/$BKP_FILE"

    echo -e "backup io :: $CONTAINER_NAME -> $BKP_FILE"
    echo -e "          :: - fetch file data and zip result"
    docker exec --user root $CONTAINER_NAME /bin/bash -c "cd $DOCKER_SRC_PATH && tar czf /tmp/$BKP_FILE ."
    echo -e "          :: - move file to backup path"
    docker exec --user root $CONTAINER_NAME /bin/bash -c "cat /tmp/$BKP_FILE" > $BKP_FILE_TARGET
    echo -e "          :: - remove temporary files"
    docker exec --user root $CONTAINER_NAME /bin/bash -c "rm -f /tmp/$BKP_FILE"
    echo -e "          :: - copy shadow archive to dropbox.com app target path (/)"
    $CFG_DROPBOX_UPLOADER -q -f $CFG_DROPBOX_CONFIG upload $BKP_FILE_TARGET /
    echo -e "          :: \n<finished>\n"
}

# prepare local backup path
mkdir -p ${CFG_HOSTPATH}

# execute backup function call
_backup_application_files --container-name df-atls-confluence-app --docker-src-path "/var/atlassian/confluence/attachments"
_backup_application_files --container-name df-atls-jira-app       --docker-src-path "/var/atlassian/jira/data"
_backup_application_files --container-name df-atls-bitbucket-app  --docker-src-path "/var/atlassian/application-data/bitbucket/shared"

# delete files older than 30 days
find ${CFG_HOSTPATH}/* -mtime +30 -exec rm {} \;