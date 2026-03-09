#!/bin/bash
# Resolve workspace to absolute path
WORKSPACE="$(cd "$(dirname "$0")" && pwd)"

# Determine agent: first arg (if profile exists), $AGENT env var, or default "claude"
AGENT="${AGENT:-claude}"
if [ -n "$1" ] && [ -f "$WORKSPACE/agents/$1.sh" ]; then
    AGENT="$1"
    shift
fi

PROFILE="$WORKSPACE/agents/$AGENT.sh"
if [ ! -f "$PROFILE" ]; then
    echo "Unknown agent: $AGENT (no $PROFILE found)" >&2
    exit 1
fi

# Source agent profile
source "$PROFILE"

# Build allowed hosts: shared domains + agent-specific hosts
ALLOWED_HOSTS="$AGENT_HOSTS"
if [ -f "$WORKSPACE/allowed_domains.txt" ]; then
    while IFS= read -r domain; do
        [ -n "$domain" ] && ALLOWED_HOSTS="$ALLOWED_HOSTS $domain"
    done < "$WORKSPACE/allowed_domains.txt"
fi

# Command: extra args override agent default
if [ $# -gt 0 ]; then
    CMD=("$@")
else
    CMD=("${AGENT_CMD[@]}")
fi

docker run -it \
    --cap-add=NET_ADMIN \
    -e TERM=xterm-256color \
    -e ALLOWED_HOSTS="$ALLOWED_HOSTS" \
    -v "$WORKSPACE:$WORKSPACE" \
    -v "$HOME/.config/git:$HOME/.config/git" \
    "${AGENT_ENV[@]}" \
    "${AGENT_MOUNTS[@]}" \
    -w "$WORKSPACE" \
    "dcba-$USER" "${CMD[@]}"
