# dcba — Docker Container Built for Agents

Sandboxed Docker environment for running CLI coding agents
with network restrictions and host UID mapping.

Supported agents: **Claude Code**, **Codex**, **Aider**, **Gemini CLI**, **OpenCode** — and easy to add more.

## Features

- Runs any CLI agent inside an Ubuntu 24.04 container
- Maps host user UID/GID so file permissions stay correct
- Firewall (iptables) limits outbound traffic to:
  - DNS
  - Agent-specific API hosts (e.g. `api.anthropic.com`)
  - Shared domains (`registry.npmjs.org`, `github.com`, `pypi.org`, etc.)
  - Everything else is blocked
- Mounts the workspace and agent config from the host

## Quick Start

Build the image:

```sh
./build.sh
```

Run Claude Code (default agent):

```sh
./run.sh
```

Run a different agent:

```sh
./run.sh codex
./run.sh aider
./run.sh gemini
./run.sh opencode
```

## How It Works

1. **build.sh** — builds a per-user Docker image (`dcba-$USER`) with the host UID/GID baked in
2. **run.sh** — detects the agent from the first argument (or `$AGENT` env var, default `claude`), sources its profile from `agents/`, and launches the container with appropriate mounts and allowed hosts
3. **entrypoint.sh** — initializes the firewall as root, then drops to the non-root user via `gosu`
4. **init-firewall.sh** — sets up iptables rules from `$ALLOWED_HOSTS` to restrict outbound network access

## Adding a New Agent

Create `agents/<name>.sh` with three variables:

```sh
AGENT_CMD=(my-agent --flags)
AGENT_MOUNTS=(
    -v "$HOME/.my-agent:$HOME/.my-agent"
)
AGENT_HOSTS="api.example.com"
```

- `AGENT_CMD` — the command to run inside the container
- `AGENT_MOUNTS` — Docker bind mounts for agent config
- `AGENT_HOSTS` — space-separated API hosts to allow through the firewall

Shared domains in `allowed_domains.txt` are automatically included for all agents.

Then run: `./run.sh <name>`
