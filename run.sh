#!/bin/bash
# Resolve workspace to absolute path
WORKSPACE="$(cd "$(dirname "$0")" && pwd)"

docker run -it \
    --cap-add=NET_ADMIN \
    -e TERM=xterm-256color \
    -v "$WORKSPACE:$WORKSPACE" \
    -v "$HOME/.claude:$HOME/.claude" \
    -v "$HOME/.claude.json:$HOME/.claude.json" \
    -v "$HOME/.config/git:$HOME/.config/git" \
    -w "$WORKSPACE" \
    "dccc-$USER" "$@"
