AGENT_CMD=(aider --yes-always --no-suggest-shell-commands)
AGENT_MOUNTS=(
    -v "$HOME/.aider.conf.yml:$HOME/.aider.conf.yml"
)
AGENT_HOSTS="api.anthropic.com api.openai.com"
