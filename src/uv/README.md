
# uv (uv)

Installs uv (https://docs.astral.sh/uv), an extremely fast Python package and project manager from Astral. Installs the `uv` and `uvx` binaries.

## Example Usage

```json
"features": {
    "ghcr.io/talshani/devcontainer-features/uv:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | uv version to install, or "latest" for the most recent release. See https://github.com/astral-sh/uv/releases for available versions. | string | 0.11.19 |

## Notes

### What this feature installs

[uv](https://docs.astral.sh/uv) is a fast Python package and project manager that replaces pip, pip-tools, pipx, poetry, pyenv, and virtualenv workflows. This feature installs the prebuilt `uv` and `uvx` binaries from the official GitHub releases.

Both binaries are placed in `/usr/local/bin` and are on `PATH` for every user. `uvx` is the `uv tool run` shortcut for running tools in ephemeral environments.

### Python is not required up front

uv can download and manage standalone Python builds itself (`uv python install`, or implicitly when a project pins a version). You do not need a separate Python feature unless your workflow expects a system `python`.

### Version pinning

The default is set per feature release. To install a different published version, or always track the latest:

```jsonc
"features": {
    "ghcr.io/<owner>/<repo>/uv:1": { "version": "0.11.19" },
    // or
    "ghcr.io/<owner>/<repo>/uv:1": { "version": "latest" }
}
```

Available versions: see https://github.com/astral-sh/uv/releases.

### Self-update

`uv self update` rewrites the binary in place at `/usr/local/bin/uv`. In a container this lasts until the next rebuild; pin the feature `version` for a reproducible toolchain.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/talshani/devcontainer-features/blob/main/src/uv/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
