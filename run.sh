#!/bin/bash
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
source "$PROFILE"

# Combine agent-specific hosts with shared domains
ALLOWED_HOSTS="$AGENT_HOSTS $(grep -v '^#' "$WORKSPACE/allowed_domains.txt" | xargs)"

# Extra args override agent default command
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
    -v "$HOME/.config/git:$HOME/.config/git:ro" \
    "${AGENT_MOUNTS[@]}" \
    -w "$WORKSPACE" \
    "dcba-$USER" "${CMD[@]}"
