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
  - (Only) Useful when using the Microsoft "DockerV2" Task in you Azure-Pipelines

## Build Image and Run Container
1. clone this repo
2. `podman build -t podman-agent .` to build the podman-agent.
   - `docker build -t podman-agent .` Docker works ofc as well to build your image 
3. Configure the agent:
   - Open .envrc and fill out missing variables
   - Source the environment variables from .envrc in this repo with `source <(cat .envrc)`
     - If you have direnv just do a `direnv allow .` inside this repo
4. Run the agent `podman run -d --name=podman-agent --privileged --rm -e "AZP_POOL=${AZP_POOL:-Default}" -e "AZP_URL=$AZP_URL" -e "AZP_TOKEN=$AZP_TOKEN" -e "AZP_AGENT_NAME=$AZP_AGENT_NAME" podman-agent`
   - You can also run the provided runAgent.sh script but there is no more magic


## Why?
Currently I am doing the first steps with Azure Pipelines at my company (topic: container baseimage building with ADO) and there was only one offical Microsoft "Docker" Task which worked well while the ado-agent ran on a simple Linux VM. Now we decided to move that ado-agent to a containerized one, which finally runs in a Kubernetes-based container runtime.
The problem I faced during testing was that if I still want to keep using the Microsoft "DockerV2" Task in my Azure-Pipeline the new containerized agent must understand Docker commands.
But since it's never a good idea to use Docker-in-Docker (DIND) in a productive Kubernetes environment (or anywhere else) I decided to use podman instead. So I tried my luck with podman and this is what you now see. It's far away from trivial work. This requires full insight on what happens within you podman-in-podman/docker environment. I do not have this full insight - not even close.
So please be aware of this fact and use this with caution!

## Future
I am building a PodmanV1 Task for Azure-Pipelines to get rid of the `podman-docker` package. If you are also interested in let me know.

## DISCLAIMER
Do not use this in production. I have no support for you :)

## Links that helped me for this repo
- https://www.redhat.com/sysadmin/podman-inside-container
- https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops
- https://podman-desktop.io/docs/migrating-from-docker/emulating-docker-cli-with-podman
