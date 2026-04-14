# Dev Container Features

A collection of [dev container Features](https://containers.dev/implementors/features/), published to GitHub Container Registry following the [dev container Feature distribution specification](https://containers.dev/implementors/features-distribution/).

## Contents

### `mise`

Installs [mise-en-place](https://mise.jdx.dev/) via its official apt repository. After install, `mise` is on `PATH` and activated for login shells via `/etc/profile.d/mise.sh`.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/<owner>/<repo>/mise:1": {}
    }
}
```

## Repo Structure

Each Feature lives under `src/` in its own sub-folder, containing a `devcontainer-feature.json` and an `install.sh` entrypoint.

```
├── src
│   └── mise
│       ├── devcontainer-feature.json
│       ├── install.sh
│       └── README.md
```

An [implementing tool](https://containers.dev/supporting#tools) composites the documented dev container properties from `devcontainer-feature.json` and runs `install.sh` during container build.

## Distributing Features

### Versioning

Features are individually versioned by the `version` attribute in their `devcontainer-feature.json`, following semver. See the [Feature specification](https://containers.dev/implementors/features/#versioning) for details.

### Publishing

> NOTE: The Distribution spec is [here](https://containers.dev/implementors/features-distribution/). This repo uses GHCR as the backing OCI registry.

A [release workflow](.github/workflows/release.yaml) publishes each Feature to GHCR on changes to `main`. *Allow GitHub Actions to create and approve pull requests* must be enabled in `Settings > Actions > General > Workflow permissions` for the auto-generated per-Feature `README.md` (merged with any `src/<feature>/NOTES.md`) to land.

Each Feature is prefixed with the `<owner>/<repo>` namespace, e.g.:

```
ghcr.io/<owner>/<repo>/mise:1
```

The workflow also publishes a metadata package at the namespace root (`ghcr.io/<owner>/<repo>`) used by tools for Feature discovery.

### Marking Features Public

GHCR packages default to `private`. To stay in the free tier and be consumable, mark each Feature `public` from its package settings page:

```
https://github.com/users/<owner>/packages/container/<repo>%2F<feature>/settings
```

### Using private Features in Codespaces

For private GHCR Features, the token needs `package:read` and `contents:read`. Codespaces uses repo-scoped tokens, so add the permissions explicitly in `devcontainer.json`:

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/my-org/private-features/mise:1": {}
    },
    "customizations": {
        "codespaces": {
            "repositories": {
                "my-org/private-features": {
                    "permissions": {
                        "packages": "read",
                        "contents": "read"
                    }
                }
            }
        }
    }
}
```
