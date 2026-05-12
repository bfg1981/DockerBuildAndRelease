#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

if [ ! -f $SCRIPT_DIR/../REPO_NAME ]
then
  echo "You need to write the name of the repo in '$SCRIPT_DIR/../REPO_NAME'"
  exit 1
fi

REPO_NAME=$(cat $SCRIPT_DIR/../REPO_NAME)
DOCKER_PLATFORMS=${DOCKER_PLATFORMS:-linux/amd64,linux/arm64}
DOCKER_BUILDX_BUILDER=${DOCKER_BUILDX_BUILDER:-multiarch}

if [ -n "$1" ]
then
  TAG_ARGS=()
  while [ -n "$1" ]
  do
    if [ "$1" == "latest" ]
    then
      TAG_ARGS+=("-t" "$REPO_NAME")
    else
      TAG_ARGS+=("-t" "$REPO_NAME:$1")
    fi
    shift
  done
else
  TAG_ARGS=("-t" "$REPO_NAME")
fi

echo "Platforms are '$DOCKER_PLATFORMS'"
echo "Tags are '${TAG_ARGS[*]}'"

if ! docker buildx inspect "$DOCKER_BUILDX_BUILDER" >/dev/null 2>&1
then
  docker buildx create --name "$DOCKER_BUILDX_BUILDER" --driver docker-container --use
else
  docker buildx use "$DOCKER_BUILDX_BUILDER"
fi

docker buildx inspect --bootstrap
docker buildx build --pull --platform "$DOCKER_PLATFORMS" "${TAG_ARGS[@]}" --push .
