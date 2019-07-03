#!/bin/bash

######################
# Description
######################

#Publish a git repo to pod trunk assuming the git repo include a podspec file.

#REPO_URL (required) should point to the git URL where the package should reside. You may use an SSH one for this or https with credentials. Repo must include a podspec file.


######################
# Options
######################

set -x
set -e

REPO_URL=$1



######################
# Get Project directory
######################

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"
ROOT_DIR="$(pwd)"


######################
# Create working directories
######################

TEMP_WORKING_FOLDER="${BASEDIR}/temp"
GIT_CLONE_DIR="${TEMP_WORKING_FOLDER}/git-clone"

rm -rf "${TEMP_WORKING_FOLDER}"

mkdir -p "${TEMP_WORKING_FOLDER}"
mkdir -p "${GIT_CLONE_DIR}"


######################
# clone pod git
######################

git clone ${REPO_URL} "${GIT_CLONE_DIR}"


######################
# Find podspec file
######################

GIT_PODSPEC=`find ${GIT_CLONE_DIR}/*.podspec`
if [ ! -f "${GIT_PODSPEC}" ]
then
      echo "${GIT_PODSPEC} not found"
      exit
fi

######################
# Detect Versions
######################

CURRENT_VERSION="1.0.0"


######################
#Create tag
######################
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

######################
#Install bundle
######################

bundle install --path "${GIT_CLONE_DIR}/bundle"

######################
# Push to pod spec
######################

cd "${GIT_CLONE_DIR}"
bundle exec pod spec lint --verbose
bundle exec pod trunk push "${GIT_PODSPEC}"
