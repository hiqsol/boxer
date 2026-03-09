# dccc — Docker Container for Claude Code

Sandboxed Docker environment for running [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
with network restrictions and host UID mapping.

## Features

- Runs Claude Code CLI inside an Ubuntu 24.04 container
- Maps host user UID/GID so file permissions stay correct
- Firewall (iptables) limits outbound traffic to:
  - DNS
  - `api.anthropic.com`
  - `registry.npmjs.org`, `github.com`
  - Everything else is blocked
- Mounts the workspace and `~/.claude` config from the host

## Quick Start

Build the image:

```sh
./build.sh
```

Run Claude Code in any project directory:

```sh
./run.sh
```

Pass extra arguments to `claude` CLI:

```sh
./run.sh claude --help
```

## How It Works

1. **build.sh** — builds a per-user Docker image (`dccc-$USER`) with the host UID/GID baked in
2. **run.sh** — launches the container with:
   - `--cap-add=NET_ADMIN` for firewall setup
   - workspace and Claude config bind-mounted
3. **entrypoint.sh** — initializes the firewall as root, then drops to the non-root user via `gosu`
4. **init-firewall.sh** — sets up iptables rules to restrict outbound network access

## Requirements

- Docker
- Host user with UID/GID 1000 (default, configurable via build args)
- Claude Code authentication (`~/.claude` / `~/.claude.json` on the host)
