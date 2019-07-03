#!/usr/bin/env bash



######################
# Install bundle
######################


# params:
# installdir: specify install dir.

function installBundle() {
    BASEDIR="${1}"
    cd ${BASEDIR}
    bundle install --path "${BASEDIR}/bundle"
    cd -
}


######################
# Find Pod Spec File
######################

# params:
# search_dir: specify search dir.

# returns:
# export GIT_PODSPEC variable

function findPodSpecFile() {
    SEARCH_DIR="${1}"
    export GIT_PODSPEC=`find ${SEARCH_DIR}/*.podspec`
    if [ ! -f "${GIT_PODSPEC}" ]
    then
      echo "${GIT_PODSPEC} not found"
      exit
    fi
}

######################
# Detect Pod Spec Version
######################

# params:
# pod_sep_file_path: pod spec file path

# returns:
# echo the version

function findPodSpecVersion() {
    PODSPEC_CONTENT=`cat "${1}"`
    echo `[[ "$PODSPEC_CONTENT" =~ s\.version\ +=\ +\"([^\"]*)\" ]] && echo "${BASH_REMATCH[1]}" | cat`
}


######################
# Detect Pod Spec name
######################

# params:
# pod_sep_file_path: pod spec file path

# returns:
# echo the name

function findPodSpecName() {
    PODSPEC_CONTENT=`cat "${1}"`
    echo `[[ "$PODSPEC_CONTENT" =~ s\.name\ +=\ +\"([^\"]*)\" ]] && echo "${BASH_REMATCH[1]}" | cat`
}