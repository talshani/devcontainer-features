## Notes

### Per-devcontainer persistent auth

This feature mounts a Docker volume named `claude-code-data-${devcontainerId}` at `/mnt/claude-code-data` and points Claude Code at it via `CLAUDE_CONFIG_DIR`. Login credentials, session history, and settings land in the volume and survive `devcontainer up` / rebuild cycles, so you do not re-authenticate on every rebuild.

The volume name embeds the devcontainer-spec `${devcontainerId}` substitution, so **each devcontainer gets its own volume**. Auth state is scoped to one project — it is intentionally **not** shared across projects on the same host.

### Environment variables set

| Variable | Value |
| --- | --- |
| `CLAUDE_CONFIG_DIR` | `/mnt/claude-code-data` |

### Resetting auth / wiping state

```bash
docker volume ls | grep claude-code-data-
docker volume rm <volume-name>
```

The volume is re-created empty on the next `devcontainer up`.
