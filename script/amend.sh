#!/bin/bash

sys_log="/dev/null"
NGINX_CONF_PATH="./nginx.conf"

function log() {
    local date
    date=$(date)
    echo "$1"
    echo "$date: $1" >> $sys_log
}

function main() {
    if [ ! $# -eq 1 ]; then
        log "[Error] amend.sh para err"
        log "eg: sh amend.sh 114.114.114.114"
        return 1
    fi

    oldServer=$1
    nameserver=$(grep "nameserver" /etc/resolv.conf | awk '{print $2}')
    if [ -z "${nameserver}" ]; then
        return   # 空行则直接跳过
    fi

    osType=$(uname -a | grep Linux)
    if [ -z "${osType}" ]; then
        sed -i '' -e "s/${oldServer}/$nameserver/g" "${NGINX_CONF_PATH}"  # mac
    else
        sed -i "s/${oldServer}/$nameserver/g" "${NGINX_CONF_PATH}"  # linux
    fi
    
}

main "$@"
