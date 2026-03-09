AGENT_CMD=(claude --dangerously-skip-permissions)
AGENT_MOUNTS=(
    -v "$HOME/.local/bin/claude:$HOME/.local/bin/claude:ro"
    -v "$HOME/.local/share/claude:$HOME/.local/share/claude"
    -v "$HOME/.claude:$HOME/.claude"
    -v "$HOME/.claude.json:$HOME/.claude.json"
)
AGENT_HOSTS="api.anthropic.com"
