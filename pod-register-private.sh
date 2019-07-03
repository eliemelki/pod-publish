#!/usr/bin/env bash

######################
# Description
######################

# Register for private pods


######################
# Parameters
######################

# POD_SPEC_NAME (required) the pod spec repo name
# POD_SPEC_URL (required) the pod spec repo url

######################
# usage
######################

# ./pod-register-private ${POD_SPEC_NAME} ${POD_SPEC_URL}

######################
# Options
######################

set -x
set -e

######################
# Variables
######################
POD_SPEC_NAME=$1
POD_SPEC_URL=$2

######################
# Functions
######################

function exportMainDirectories() {
    SHELL_FILE=$1
    export BASEDIR="$( cd "$(dirname "$SHELL_FILE")" ; pwd -P )"
    export ROOT_DIR="$(pwd)"
}

function processPrivatePodExists() {
    cd "${POD_REPO_DIRECTORY}"
    POD_GIT_URL=`git config --get remote.origin.url`
    if [ "${POD_GIT_URL}" = "${POD_SPEC_URL}" ]
    then
        echo "Already registered"
    else
        echo "Pod repo name ${POD_SPEC_NAME} and ${POD_GIT_URL} exists. The repo git is different from the one you specified ${POD_SPEC_URL}. Are you sure about that ?"
        exit 1
    fi
}

function registerPrivatePod() {
    POD_REPO_DIRECTORY="$HOME/.cocoapods/repos/${POD_SPEC_NAME}/"
    if [ -d "${POD_REPO_DIRECTORY}" ]; then
        processPrivatePodExists
    else
        bundle exec pod repo add ${POD_SPEC_NAME} ${POD_SPEC_URL}
    fi

}

######################
# main
######################

exportMainDirectories "$0"
source ${BASEDIR}/common.sh
installBundle "${BASEDIR}"
registerPrivatePod


