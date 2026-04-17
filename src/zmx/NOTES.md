## Notes

### What this feature installs

[zmx](https://zmx.sh) is a shell session persistence tool. Use it to start a shell you can detach from and reattach to later, with multiple clients able to attach to the same session. Unlike tmux/screen it deliberately does not handle windows or panes.

The `zmx` binary is placed at `/usr/local/bin/zmx` and is on `PATH` for every user.

### Session state is not persisted across rebuilds

zmx sessions are in-memory daemon state. If the container is destroyed, sessions are gone. This feature intentionally does not mount a Docker volume — there is nothing filesystem-shaped to persist.

### Version pinning

The default is set per feature release. To install a different published version:

```jsonc
"features": {
    "ghcr.io/<owner>/<repo>/zmx:1": { "version": "0.5.0" }
}
```

Available versions: see https://zmx.sh.
