AGENT_ENV=(-e GOOSE_MODE=auto)
AGENT_CMD=(goose session)
AGENT_MOUNTS=(
    -v "$HOME/.config/goose:$HOME/.config/goose"
)
AGENT_HOSTS="api.anthropic.com api.openai.com"
