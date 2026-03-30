# Docker-in-Docker for Boxer

## Why Docker is needed

Claude Code itself does NOT require Docker — it's a Node.js CLI tool that uses
bubblewrap for sandboxing on Linux. However, Docker is needed inside the container
to run user projects that depend on Docker (docker-compose, building images, etc.).

## Approaches

### 1. Host socket mount (recommended)

Mount the host's Docker socket into the container. The `docker` CLI inside the
container controls the host's Docker daemon — containers are siblings, not nested.

**Pros:**
- No `--privileged` mode needed
- No storage driver nesting issues (overlay2-in-overlay2)
- No conflict with iptables firewall (dockerd manipulates iptables heavily)
- Simple setup

**Cons:**
- Container gets root-equivalent access to the host via the socket
- Sibling containers run on the host, not inside boxer
- Firewall rules don't apply to sibling containers

**Implementation:**
1. Install `docker-cli` only (not full daemon) in Dockerfile
2. Mount `/var/run/docker.sock` in compose/run config
3. Add container user to the `docker` group (matching host GID)

### 2. Full Docker-in-Docker (dockerd inside container)

Run a full Docker daemon inside the container.

**Pros:**
- Full isolation — nested containers live inside boxer
- Firewall rules apply to everything

**Cons:**
- Requires `--privileged` or extensive capabilities (weakens isolation)
- Storage driver conflicts — overlay2 inside overlay2 doesn't work; must use
  `vfs` (slow, disk-heavy) or mount a dedicated volume for `/var/lib/docker`
- `dockerd` manipulates iptables, conflicts with `init-firewall.sh` DROP rule
- Docker daemon needs root, but entrypoint drops to non-root via `gosu`
- Significantly more complex setup

### 3. Sysbox runtime

Use [Sysbox](https://github.com/nestybox/sysbox) as the container runtime,
which enables rootless Docker-in-Docker without `--privileged`.

**Pros:**
- Secure DinD without `--privileged`
- Proper filesystem isolation

**Cons:**
- Requires installing Sysbox on the host
- Less common, may have compatibility issues

## Decision

**Socket mount is the recommended approach** for this project:
- The container is for local development on a personal machine
- Root-equivalent host access via socket is acceptable in this context
- Avoids all the complexity and conflicts of running dockerd inside the container

## Boxer comparison to Anthropic's reference devcontainer

| Aspect | Anthropic Reference | Boxer |
|--------|-------------------|-------|
| Base image | Node.js 20 | Ubuntu 24.04 |
| Firewall | iptables + ipset, fetches GitHub CIDRs | iptables, resolves hosts via DNS |
| Domain config | Hardcoded in script | `ALLOWED_HOSTS` env var |
| User setup | `node` (hardcoded) | Matches host UID/GID |
| Claude install | `npm i -g` in Dockerfile | Bind-mounted from host |
| Docker | Not included | Planned: socket mount |

## References

- [Sandboxing - Claude Code Docs](https://code.claude.com/docs/en/sandboxing)
- [Development containers - Claude Code Docs](https://code.claude.com/docs/en/devcontainer)
- [Claude Code sandbox - Docker Docs](https://docs.docker.com/ai/sandboxes/agents/claude-code/)
- [Anthropic reference devcontainer](https://github.com/anthropics/claude-code/tree/main/.devcontainer)
- [Sysbox - GitHub](https://github.com/nestybox/sysbox)
