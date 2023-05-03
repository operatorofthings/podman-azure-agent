# Build an image containing an Ubuntu 23.04 environment which acts as an azure-pipelines agent.
# This image will contain podman to manage containers within your azure-pipelines.
# This image should be run with --cap-add SYS_ADMIN --device /dev/fuse for a rootfull podman in rootfull container-environment.
# This image could be run with --user=podman and --cap-add SYS_ADMIN --device /dev/fuse for a rootless podman in a rootfull container-environment
# Please be aware that podman will warn you if you do not use --privileged or --cap-add SYS_ADMIN --device /dev/fuse mode.
FROM ubuntu:23.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lsb-release \
    software-properties-common \
    podman \
    fuse-overlayfs \
    podman-docker

###### PODMAN #######

# This is only needed for podman-docker to suppress the 'Emulate Docker CLI using podman' message.
RUN touch /etc/containers/nodocker

RUN useradd podman && usermod --add-subuids 100000-165535 --add-subgids 100000-165535 podman

# basic upstream podman configuration files
ARG _REPO_URL="https://raw.githubusercontent.com/containers/podman/main/contrib/podmanimage/stable"
ADD $_REPO_URL/containers.conf /etc/containers/containers.conf
ADD $_REPO_URL/podman-containers.conf /home/podman/.config/containers/containers.conf

# used for rootless in rootfull mode
RUN mkdir -p /home/podman/.local/share/containers && \
    chown podman:podman -R /home/podman && \
    chmod 644 /etc/containers/containers.conf

# Note VOLUME options must always happen after the chown call above
# RUN commands can not modify existing volumes
VOLUME /var/lib/containers
VOLUME /home/podman/.local/share/containers

RUN mkdir -p /var/lib/shared/overlay-images \
             /var/lib/shared/overlay-layers \
             /var/lib/shared/vfs-images \
             /var/lib/shared/vfs-layers && \
    touch /var/lib/shared/overlay-images/images.lock && \
    touch /var/lib/shared/overlay-layers/layers.lock && \
    touch /var/lib/shared/vfs-images/images.lock && \
    touch /var/lib/shared/vfs-layers/layers.lock

# Copy custom storage.conf file
COPY assets/podman/storage.conf /etc/containers/storage.conf

ENV _CONTAINERS_USERNS_CONFIGURED=""

####### ADO AGENT ########

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64

WORKDIR /azp

# edited start.sh to replace docker with podman commands
COPY assets/ado/start.sh .
RUN chmod +x start.sh

ENTRYPOINT [ "./start.sh" ]
