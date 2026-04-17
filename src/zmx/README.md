
# zmx (zmx)

Installs zmx (https://zmx.sh), a shell session persistence tool. Attach/detach from shell sessions without killing them; multiple clients can attach to the same session.

## Example Usage

```json
"features": {
    "ghcr.io/talshani/devcontainer-features/zmx:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | zmx version to install. See https://zmx.sh for available versions. | string | 0.5.0 |

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


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/talshani/devcontainer-features/blob/main/src/zmx/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
