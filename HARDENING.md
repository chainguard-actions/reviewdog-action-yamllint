<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-yamllint/v1.23.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-yamllint/v1.23.0** was hardened automatically. 6 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The `run:` block in dockerimage.yml directly interpolates `${{ github.repository }}` into a shell command string. This allows YAML template substitution to inject arbitrary shell metacharacters before the shell ever sees the value. Offending line: `run: docker build . --file Dockerfile --tag ${{ github.repository }}:$(date +%s)`

Locations:

- `.github/workflows/dockerimage.yml:12`

### script-injection (severity: high)

Sub-rule (b): In entrypoint.sh, the shell variables `${INPUT_YAMLLINT_FLAGS:-'.'}` (line 11) and `${INPUT_REVIEWDOG_FLAGS}` (line 20) are expanded unquoted in shell commands. These variables hold values sourced from workflow `inputs.*` (yamllint_flags and reviewdog_flags), which are workflow-controllable. Unquoted expansion allows shell metacharacters (`;`, `|`, `&`, `$(...)`, whitespace, globs) to be interpreted by the shell, enabling command injection.

Locations:

- `entrypoint.sh:11`
- `entrypoint.sh:20`

### unpinned-uses (severity: high)

The `action.yml` docker action references the image `docker://ghcr.io/reviewdog/action-yamllint:v1.23.0` using a mutable version tag (`v1.23.0`) rather than an immutable SHA digest. A supply-chain attacker could push a malicious image to the same tag. The image reference should use a SHA digest, e.g. `docker://ghcr.io/reviewdog/action-yamllint@sha256:<64-hex-char-digest>`.

Locations:

- `action.yml:44`

### permissions (severity: medium)

missing-permissions: The workflow file `depup.yml` has no top-level `permissions:` key and no job-level `permissions:` key on any of its jobs. Without explicit permissions, the workflow inherits the repository default (often `write-all`), granting overly broad access to the GITHUB_TOKEN.

Locations:

- `.github/workflows/depup.yml:1`

### permissions (severity: medium)

missing-permissions: The workflow file `dockerimage.yml` has no top-level `permissions:` key and no job-level `permissions:` key on any of its jobs. Without explicit permissions, the workflow inherits the repository default (often `write-all`), granting overly broad access to the GITHUB_TOKEN.

Locations:

- `.github/workflows/dockerimage.yml:1`

### permissions (severity: medium)

missing-permissions: The workflow file `reviewdog.yml` has no top-level `permissions:` key and no job-level `permissions:` key on any of its jobs. Without explicit permissions, the workflow inherits the repository default (often `write-all`), granting overly broad access to the GITHUB_TOKEN.

Locations:

- `.github/workflows/reviewdog.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, unpinned-uses, permissions

**Notes:**

Fixed all 6 findings across 5 files:
1. dockerimage.yml (script-injection): Moved `${{ github.repository }}` into an `env:` block as `REPOSITORY` and used `"$REPOSITORY"` in the shell command.
2. entrypoint.sh (script-injection): Added `set -f` (noglob) before unquoted flag variable expansions to prevent glob injection while preserving intentional word-splitting for multi-word flag strings.
3. action.yml (unpinned-uses): Pinned `docker://ghcr.io/reviewdog/action-yamllint:v1.23.0` to immutable digest `sha256:24d7867c4c2b27337212785f44824cd566bac158efb69dfc9479f9a6b5fdb789`, preserving the `docker://` scheme and tag.
4. depup.yml (permissions): Added `permissions: contents: write, pull-requests: write` (required for creating PRs).
5. dockerimage.yml (permissions): Added `permissions: contents: read`.
6. reviewdog.yml (permissions): Added `permissions: contents: read, pull-requests: write`.

