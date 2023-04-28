#!/bin/bash

podman run -d --name=podman-agent --privileged --rm -e "AZP_URL=$AZP_URL" -e "AZP_TOKEN=$AZP_TOKEN" -e "AZP_AGENT_NAME=mydockeragent" podman-agent:0.9.1
