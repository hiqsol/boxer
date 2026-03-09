AGENT_CMD=(opencode --dangerously-skip-permissions)
AGENT_MOUNTS=(
    -v "$HOME/.config/opencode:$HOME/.config/opencode"
)
AGENT_HOSTS="api.anthropic.com api.openai.com"
