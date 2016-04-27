#!/usr/bin/env bash

##################################################################
# Script: make_ssh_config.sh                                     #
# Web: https://github.com/meyju/ssh_config_dir                   #
#                                                                #
# Copyright (C) 2016 Julian Meyer <jm@julianmeyer.de>            #
#                                                                #
# This program is free software; you can redistribute it and/or  #
# modify it under the terms of the GNU General Public License    #
# as published by the Free Software Foundation; either version 2 #
# of the License, or (at your option) any later version.         #
##################################################################

# Try to get a config file
if [ "$#" -lt 1 ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    CONFIG_FILE="$DIR/config"
    if [ ! -e $CONFIG_FILE ];then
        echo "ERROR: Can't find default config"
        exit 1
    fi
else
    CONFIG_FILE="$1"
    if [ ! -e $CONFIG_FILE ];then
        echo "ERROR: Can't load config: $1"
        exit 1
    fi
fi

# Load config file
source $CONFIG_FILE

if [[ -z "$SSH_CONFIG" || -z "$SSH_CONFD" || -z "$START_MARK" || -z "$END_MARK" ]]; then
    echo "ERROR: There are not all variables set in your config"
    exit 2
fi

# Get cutting marks
MARK_BEGIN=$(cat ${SSH_CONFIG} | grep -n "${START_MARK}" | sed 's/\(.*\):.*/\1/g')
MARK_END=$(cat ${SSH_CONFIG} | grep -n "${END_MARK}" | sed 's/\(.*\):.*/\1/g')

FAIL=false
if [[ -z "$MARK_BEGIN" ]]; then
    echo "ERROR: can't find starting cutting mark!"
    FAIL=true
fi
if [[ -z "$MARK_END" ]]; then
    echo "ERROR: can't find ending cutting mark!"
    FAIL=true
fi
if [ $FAIL = true ]; then
    exit 1
fi

if [[ "$SSH_CONFD" != */ ]]; then
    SSH_CONFD="$SSH_CONFD/"
fi

TEMPD="$(mktemp -d)"
TEMPF=$(mktemp)
cp -r ${SSH_CONFD}* ${TEMPD}/
echo "${START_MARK}" > ${TEMPD}/000000001
echo "${END_MARK}" > ${TEMPD}/ZZZZZZZZZZ

function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}
function_exists PRE_HOOK && PRE_HOOK

# get all together
cat <(head -n $(expr ${MARK_BEGIN} - 1) ${SSH_CONFIG}) ${TEMPD}/* <(tail -n +$(expr ${MARK_END} + 1) ${SSH_CONFIG}) > ${TEMPF}
mv ${TEMPF} ${SSH_CONFIG}
rm -rf ${TEMPD}
