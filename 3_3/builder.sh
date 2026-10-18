#!/usr/bin/env bash
set -e

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <github-repo> <dockerhub-repo>"
  exit 1
fi

GITHUB_REPO="$1"
DOCKERHUB_REPO="$2"

git clone "https://github.com/${GITHUB_REPO}.git" temp_repo
docker build -t "$DOCKERHUB_REPO" temp_repo
docker push "$DOCKERHUB_REPO"
rm -rf temp_repo
