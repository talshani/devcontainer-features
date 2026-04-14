## Notes

### Persistent cache across container rebuilds

This feature mounts a named Docker volume `mise-data-volume` at `/mnt/mise-data` and points mise at it via `MISE_DATA_DIR`. Tool downloads (node, python, etc.) land in the volume and survive `devcontainer up` / rebuild cycles, so you do not re-download toolchains on every rebuild.

### Environment variables set

| Variable | Value |
| --- | --- |
| `MISE_DATA_DIR` | `/mnt/mise-data` |
| `MISE_GLOBAL_CONFIG_FILE` | `/mnt/mise-data/global-config.toml` |
| `MISE_TRUSTED_CONFIG_PATHS` | `/workspaces` |

`MISE_TRUSTED_CONFIG_PATHS=/workspaces` auto-trusts any `.mise.toml` under your workspace so project-level tool versions load without an interactive prompt.

### Sharing the cache across projects

Because the volume name is fixed (`mise-data-volume`), every devcontainer that uses this feature on the same Docker host shares one cache. Installing `node@22` in project A means project B gets it for free.

### Resetting the cache

```bash
docker volume rm mise-data-volume
```

The volume is re-created empty on the next `devcontainer up`.
