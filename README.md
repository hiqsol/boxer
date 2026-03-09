# boxer — Docker sandbox for CLI coding agents

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
./boxer build
```

Run Claude Code (default agent):

```sh
./boxer
```

Run a different agent:

```sh
./boxer codex
./boxer aider
./boxer gemini
./boxer opencode
```

Override the command (e.g. open a shell with agent config mounted):

```sh
./boxer claude -- bash
```

## How It Works

1. **boxer** — Python CLI that reads agent configs from `agents/*.yaml`, builds docker arguments (mounts, allowed hosts, command), and launches the container
2. **docker/entrypoint.sh** — initializes the firewall as root, then drops to the non-root user via `gosu`
3. **docker/init-firewall.sh** — sets up iptables rules from `$ALLOWED_HOSTS` to restrict outbound network access

## Adding a New Agent

Create `agents/<name>.yaml`:

```yaml
cmd: my-agent --flags
hosts:
  - api.example.com
mounts:
  - ~/.config/my-agent
  - ~/.my-agent-rc:ro
```

- `cmd` — the command to run inside the container
- `hosts` — API hosts to allow through the firewall
- `mounts` — bind mounts from host; paths starting with `~/` expand to `$HOME`, append `:ro` for read-only

Shared domains in `allowed_domains.txt` are automatically included for all agents.

Then run: `./boxer <name>`
