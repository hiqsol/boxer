AGENT_CMD=(codex --full-auto --approval-mode never)
AGENT_MOUNTS=(
    -v "$HOME/.codex:$HOME/.codex"
)
AGENT_HOSTS="api.openai.com"
