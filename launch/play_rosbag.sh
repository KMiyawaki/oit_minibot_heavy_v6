#!/bin/bash

function main() {
    local -r PKG="oit_minibot_heavy_v6"
    local -r LAUNCH="play_rosbag.launch"
    local -r PARAM_NAME="bag"
    local -r MIN_ARG=1
    if [ $# -lt "${MIN_ARG}" ]; then
        echo "${FUNCNAME[0]} 引数は ${MIN_ARG} 個以上必要です。" 1>&2
        echo "usage: ${FUNCNAME[0]} [bag filename]" 1>&2
        return 1
    fi
    
    local -r BAG_FILE=`basename ${1}`
    local -r ADDITIONAL="${@:2:($#-1)}"
    local -r CMD="roslaunch ${PKG} ${LAUNCH} ${PARAM_NAME}:=${BAG_FILE} ${ADDITIONAL}"
    # echo ${CMD}
    eval ${CMD}
}

main "$@"
