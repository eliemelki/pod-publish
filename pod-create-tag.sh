#!/usr/bin/env bash

######################
# Description
######################

# Create  tag

######################
# Parameters
######################

# GIT_URL (required): should point to the git URL where the package should reside. You may use an SSH one for this or https with credentials. Repo must include a podspec file.

######################
# usage
######################

# ./pod-create-tag ${GIT_URL}

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
# Export working directories
######################
function exportMainDirectories() {
    SHELL_FILE=$1
    export BASEDIR="$( cd "$(dirname "$SHELL_FILE")" ; pwd -P )"
    export ROOT_DIR="$(pwd)"
}


######################
# Create working directories
######################

function createTempDirectories() {
    export TEMP_WORKING_FOLDER="${BASEDIR}/temp"
    export GIT_CLONE_DIR="${TEMP_WORKING_FOLDER}/git-clone"

    rm -rf "${TEMP_WORKING_FOLDER}"

    mkdir -p "${TEMP_WORKING_FOLDER}"
    mkdir -p "${GIT_CLONE_DIR}"
}

######################
# clone pod git
######################

# params:
# GIT_URL
# GIT_CLONE_DIR
function cloneProject() {
    git clone "${1}" "${2}"
}

######################
# create Tag
######################

# params:
# GIT_CLONE_DIR
# VERSION
function createTag() {
    GIT_CLONE_DIR="${1}"
    CURRENT_VERSION="${2}"

    cd "${GIT_CLONE_DIR}"
    TAG_EXITS=`git ls-remote origin refs/tags/${CURRENT_VERSION}`
    if [ "${TAG_EXITS}" ]
    then
      echo "Tag exists"
      git tag -d ${CURRENT_VERSION}
      git push origin :refs/tags/${CURRENT_VERSION}
    fi

    git commit --allow-empty -m "Release ${CURRENT_VERSION}"
    git tag "${CURRENT_VERSION}"
    git push --tags
    cd -
}


######################
# main
######################

exportMainDirectories "$0"
source ${BASEDIR}/common.sh
createTempDirectories
cloneProject "${GIT_URL}" "${GIT_CLONE_DIR}"
findPodSpecFile "${GIT_CLONE_DIR}"
VERSION=`findPodSpecVersion "${GIT_PODSPEC}"`
createTag "${GIT_CLONE_DIR}" "${VERSION}"
