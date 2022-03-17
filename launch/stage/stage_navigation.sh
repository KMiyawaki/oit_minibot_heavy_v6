#!/bin/bash

function main() {
  local -r LAUNCH="stage_navigation.launch"
  local -r PARAM_NAME="map_name"
  local -r MIN_ARG=1
  if [ $# -lt "${MIN_ARG}" ]; then
    echo "${FUNCNAME[0]} 引数は ${MIN_ARG} 個以上必要です。" 1>&2
    echo "usage: ${FUNCNAME[0]} [bag filename]" 1>&2
    return 1
  fi
  
  local MAP_NAME=`basename ${1}`
  MAP_NAME="${MAP_NAME%.*}"
  local -r ADDITIONAL="${@:2:($#-1)}"
  local -r CMD="roslaunch ${LAUNCH} ${PARAM_NAME}:=${MAP_NAME} ${ADDITIONAL}"
  #echo ${CMD}
  eval ${CMD}
}

main "$@"
