#!/bin/bash
# Script to run image (param 1 or 'podman-agent') with tag (param 2 or 'latest')
# Runs in detached mode (-d)
# Runs (softer) privileged mode with --cap-add SYS_ADMIN --device /dev/fuse
# -> SYS_ADMIN is needed for mount/umount functionality
# -> /dev/fuse exposes the FUSE device to the container
# Takes $ENV_VARS from .envrc
# Is named 'podman-agent'

IMAGE_NAME="${1:-podman-agent}"
IMAGE_TAG="${2:-latest}"

podman run -d --name=podman-agent --cap-add SYS_ADMIN --device /dev/fuse --rm -e "AZP_POOL=${AZP_POOL:-Default}" -e "AZP_URL=$AZP_URL" -e "AZP_TOKEN=$AZP_TOKEN" -e "AZP_AGENT_NAME=$AZP_AGENT_NAME" $IMAGE_NAME:$IMAGE_TAG
