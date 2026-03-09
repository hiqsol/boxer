AGENT_CMD=(gemini --sandbox none)
AGENT_MOUNTS=(
    -v "$HOME/.config/gemini:$HOME/.config/gemini"
)
AGENT_HOSTS="generativelanguage.googleapis.com"
