# podman-azure-agent
The podman-azure-agent is basically a containerized Microsoft Azure-Pipelines Agent, which bases on Ubuntu:23.04 and uses podman (https://podman.io) to let you manage containers within your Azure-Pipelines (while already inside a container).

## Summary
- Containerized Microsoft Azure-Pipelines agent
- Based on Ubuntu 23.04
- Uses podman to manage containers from your Azure-Pipelines (PINP approach)
- Supports:
  - rootfull podman in rootfull podman/docker environment
  - rootless podman in rootfull podman/docker environment
- Currently uses `podman-docker` to be able to "translate" Docker commands to podman
  - (Only) Useful when using the Microsoft "DockerV2" Task in your Azure-Pipelines

## Build Image and Run Container
1. clone this repo
2. `podman build -t podman-agent .` to build the podman-agent.
   - `docker build -t podman-agent .` Docker works ofc as well to build your image 
3. Configure the agent:
   - Open .envrc and fill out missing variables
   - Source the environment variables from .envrc in this repo with `source <(cat .envrc)`
     - If you have direnv just do a `direnv allow .` inside this repo
4. Run the agent `podman run -d --name=podman-agent --cap-add SYS_ADMIN --device /dev/fuse --rm -e "AZP_POOL=${AZP_POOL:-Default}" -e "AZP_URL=$AZP_URL" -e "AZP_TOKEN=$AZP_TOKEN" -e "AZP_AGENT_NAME=$AZP_AGENT_NAME" podman-agent`
   - You can also run the provided runAgent.sh script but there is no more magic


## DISCLAIMER
I recommend you to not use this in production unless you are totally aware of what you are doing.

## Links that helped me for this repo
- https://www.redhat.com/sysadmin/podman-inside-container
- https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops
- https://podman-desktop.io/docs/migrating-from-docker/emulating-docker-cli-with-podman
