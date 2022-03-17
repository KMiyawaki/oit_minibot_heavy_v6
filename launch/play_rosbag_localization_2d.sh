#!/bin/bash

function main() {
    local -r PKG="oit_minibot_heavy_v6"
    local -r LAUNCH="play_rosbag_localization_2d.launch"
    local -r PARAM_BAG="bag"
    local -r PARAM_MAP="map_name"
    local -r MIN_ARG=2
    if [ $# -lt "${MIN_ARG}" ]; then
        echo "${FUNCNAME[0]} 引数は ${MIN_ARG} 個以上必要です。" 1>&2
        echo "usage: ${FUNCNAME[0]} [bag filename map filename]" 1>&2
        return 1
    fi
    
    local -r BAG_FILE=`basename ${1}`
    local MAP_NAME=`basename ${2}`
    MAP_NAME="${MAP_NAME%.*}"
    local -r ADDITIONAL="${@:3:($#-1)}"
    local -r CMD="roslaunch ${PKG} ${LAUNCH} ${PARAM_BAG}:=${BAG_FILE} ${PARAM_MAP}:=${MAP_NAME} ${ADDITIONAL}"
    #echo ${CMD}
    eval ${CMD}
}

main "$@"
