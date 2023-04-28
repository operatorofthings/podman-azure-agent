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
I am using Azure Pipelines and there was only an offical Microsoft "Docker" Task which worked well while the corresponding agent ran on a VM. Now my company moved that agent to containerized one which now runs on Kubernetes.
The problem I faced was that if I still want to keep using the Microsoft "DockerV2" Task in my pipeline the new containerized agent should be able to understand Docker commands.
But it's never a good idea to use Docker-in-Docker (DIND) in a productive Kubernetes environment (or anywhere else). So I tried my luck with podman and this is what you now see.

## Future
I am building a PodmanV1 Task for Azure-Pipelines to get rid of the `podman-docker` package. If you are also interested in let me know.



