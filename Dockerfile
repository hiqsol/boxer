FROM ubuntu:24.04

ARG USERNAME
ARG HOST_UID
ARG HOST_GID

RUN apt-get update && apt-get install -y \
    bash curl git build-essential \
    python3 python3-pip nodejs npm fish neovim git-lfs \
    iptables iproute2 gosu \
    && apt-get autoremove --purge -y \
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
