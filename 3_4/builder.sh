#!/bin/sh
set -e

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <github-repo> <dockerhub-repo>"
  exit 1
fi

GITHUB_REPO="$1"
DOCKERHUB_REPO="$2"

git clone "https://github.com/${GITHUB_REPO}.git" temp_repo
docker build -t "$DOCKERHUB_REPO" temp_repo
echo "$DOCKER_PWD" | docker login -u "$DOCKER_USER" --password-stdin
docker push "$DOCKERHUB_REPO"
rm -rf temp_repo
