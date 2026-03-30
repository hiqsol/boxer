FROM ubuntu:24.04

ARG USERNAME
ARG HOST_UID
ARG HOST_GID

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash curl wget git build-essential \
    python3 python3-pip nodejs npm fish neovim git-lfs \
    sudo iputils-ping iptables iproute2 gosu \
    openssh-client ca-certificates gnupg \
    jq yq zip unzip tar gzip \
    htop less tree tmux \
    net-tools dnsutils strace lsof \
    ripgrep fd-find fzf bat \
    man-db file \
    software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y --no-install-recommends \
    python3.10 python3.10-venv python3.10-distutils \
    && python3.10 -m ensurepip --upgrade \
    && apt-get autoremove --purge -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create user with host UID/GID (remove conflicting ubuntu user/group if present)
RUN userdel -r "$(id -nu "$HOST_UID" 2>/dev/null)" 2>/dev/null; \
    groupdel "$(getent group "$HOST_GID" | cut -d: -f1)" 2>/dev/null; \
    groupadd -g "$HOST_GID" "$USERNAME" \
    && useradd -m -u "$HOST_UID" -g "$HOST_GID" -s /bin/bash "$USERNAME"

ENV PATH="/home/$USERNAME/.local/bin:$PATH"

COPY docker/init-firewall.sh docker/entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/init-firewall.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
