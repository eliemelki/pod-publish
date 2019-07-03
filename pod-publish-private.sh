#!/usr/bin/env bash

######################
# Description
######################

#Publish a git repo to private pod trunk assuming the git repo include a podspec file.


######################
# Parameters
######################

# GIT_URL (required) should point to the git URL where the library exists. You may use an SSH one for this or https with credentials. Repo must include a podspec file.
# POD_SEPC_NAME (required): Private pod spec repo name
# POD_SPEC_URL (required): Private pod spec repo git url


######################
# usage
######################

# ./pod-pubish-private $${GIT_URL} ${POD_SPEC_NAME} ${POD_SPEC_URL}

######################
# Options
######################

set -x
set -e

######################
# Variables
######################
GIT_URL=$1
POD_SEPC_NAME=$2
POD_SPEC_URL=$3


######################
# Functions
######################
function exportMainDirectories() {
    SHELL_FILE=$1
    export BASEDIR="$( cd "$(dirname "$SHELL_FILE")" ; pwd -P )"
    export ROOT_DIR="$(pwd)"
}

######################
# main
######################

exportMainDirectories "$0"
source "${BASEDIR}/common.sh"
"${BASEDIR}/pod-register-private.sh" $POD_SEPC_NAME $POD_SPEC_URL
source "${BASEDIR}/pod-create-tag.sh" $GIT_URL
cd "${GIT_CLONE_DIR}"
bundle exec pod spec lint --private --verbose
bundle exec pod repo push "${GIT_PODSPEC}" --allow-warnings



