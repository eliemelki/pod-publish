#!/usr/bin/env bash

######################
# Description
######################

# Publish a git repo to pod trunk assuming the git repo include a podspec file.


######################
# Parameters
######################

# REPO_URL (required) should point to the git URL where the package should reside. You may use an SSH one for this or https with credentials. Repo must include a podspec file.

######################
# usage
######################

# ./pod-pubish-trunk ${GIT_URL}

######################
# Options
######################

set -x
set -e

######################
# Variables
######################
GIT_URL=$1

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
source "${BASEDIR}/pod-create-tag.sh" $REPO_URL
installBundle "${BASEDIR}"
cd "${GIT_CLONE_DIR}"
bundle exec pod spec lint --verbose
bundle exec pod trunk push "${GIT_PODSPEC}"
