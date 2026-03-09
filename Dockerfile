FROM ubuntu:24.04

ARG USERNAME=sol
ARG HOST_UID=1000
ARG HOST_GID=1000

RUN apt-get update && apt-get install -y \
    bash curl git build-essential \
    python3 nodejs npm fish neovim \
    iptables iproute2 gosu \
    && rm -rf /var/lib/apt/lists/*

# Create user with host UID/GID (remove conflicting ubuntu user/group if present)
RUN userdel -r "$(id -nu "$HOST_UID" 2>/dev/null)" 2>/dev/null; \
    groupdel "$(getent group "$HOST_GID" | cut -d: -f1)" 2>/dev/null; \
    groupadd -g "$HOST_GID" "$USERNAME" \
    && useradd -m -u "$HOST_UID" -g "$HOST_GID" -s /bin/bash "$USERNAME"

ENV PATH="/home/$USERNAME/.local/bin:$PATH"

COPY --chmod=755 init-firewall.sh entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
