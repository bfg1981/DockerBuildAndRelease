# DockerBuildAndRelease

Reusable Docker build-and-push helper.

This repository contains `build_and_push.sh`, a small script intended to be used
as a submodule named `release` inside Docker image repositories. It builds and
pushes multi-architecture Docker images with `docker buildx`.

## Usage

In the parent repository, create a `REPO_NAME` file next to the `release`
submodule:

```text
therealbfg/example-image
```

Then run:

```sh
./release/build_and_push.sh latest
```

Multiple tags can be supplied:

```sh
./release/build_and_push.sh latest 1.2.3
```

If no tag is supplied, the image is pushed as the bare repository name.

## Configuration

Environment variables:

- `DOCKER_PLATFORMS` - build platforms, default `linux/amd64,linux/arm64`.
- `DOCKER_BUILDX_BUILDER` - buildx builder name, default `multiarch`.

The script creates or selects the configured buildx builder, bootstraps it, and
then runs:

```sh
docker buildx build --pull --platform "$DOCKER_PLATFORMS" --push .
```

## Known Consumers

This repository is used as the `release` submodule in several `git_httpd`
container repositories.
