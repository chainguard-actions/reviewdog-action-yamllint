<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-yamllint/v1.23.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-yamllint/v1.23.1** was hardened automatically. 4 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

Dockerfile pipes remote content directly to a shell interpreter: `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/.../install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}`. The script should be downloaded to a file first, verified, and then executed separately.

Locations:

- `Dockerfile:5`

### script-injection (severity: high)

Sub-rule (a): A GitHub Actions expression is interpolated directly inside a `run:` shell command. In `.github/workflows/dockerimage.yml`, the `run:` step contains `${{ github.repository }}` directly in the shell command string: `docker build . --file Dockerfile --tag ${{ github.repository }}:$(date +%s)`. This allows template substitution to inject arbitrary shell metacharacters before the shell parses the command.

Locations:

- `.github/workflows/dockerimage.yml:13`

### unpinned-uses (severity: high)

The `runs.image:` field in action.yml references a mutable Docker image tag instead of a SHA digest: `docker://ghcr.io/reviewdog/action-yamllint:v1.23.1`. This is vulnerable to supply-chain attacks because the tag can be silently updated to point to a different image. It should be pinned to a SHA digest, e.g. `docker://ghcr.io/reviewdog/action-yamllint@sha256:<64-hex-char-digest>`.

Locations:

- `action.yml:43`

### missing-permissions (severity: medium)

The following workflow files have no top-level `permissions:` key and none of their jobs define a `permissions:` block either. Without explicit permissions, the GITHUB_TOKEN is granted its default (potentially broad) permissions: `depup.yml` (single job `reviewdog` has no permissions), `dockerimage.yml` (single job `build` has no permissions), `reviewdog.yml` (single job `yamllint` has no permissions).

Locations:

- `.github/workflows/depup.yml:1`
- `.github/workflows/dockerimage.yml:1`
- `.github/workflows/reviewdog.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell, script-injection, unpinned-uses, missing-permissions

**Notes:**

1. Dockerfile: Replaced pipe-to-shell with download-then-execute pattern. Script is saved to /tmp/install-reviewdog.sh, executed with 'sh /tmp/install-reviewdog.sh -b /usr/local/bin/ ${REVIEWDOG_VERSION}' (dropped '--' shell option terminator as instructed), then removed. 2. dockerimage.yml: Moved ${{ github.repository }} into an env var GITHUB_REPOSITORY and referenced it as "$GITHUB_REPOSITORY" in the run command. Also added top-level 'permissions: {}'. 3. action.yml: Pinned docker://ghcr.io/reviewdog/action-yamllint:v1.23.1 to its SHA digest sha256:86b2af6fc9df12b472e0508c91cf47ba04c87b5d514a8591712321b1bb1ce68d. 4. depup.yml and reviewdog.yml: Added top-level 'permissions: {}' blocks to both workflow files.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in entrypoint.sh at lines 10 and 18:
1. INPUT_YAMLLINT_FLAGS: Was unquoted (${INPUT_YAMLLINT_FLAGS:-'.'}). Now tokenized into a bash array using xargs with a guard for the empty case (defaults to '.' when empty), then expanded as "${yamllint_flags[@]}".
2. INPUT_REVIEWDOG_FLAGS: Was unquoted (${INPUT_REVIEWDOG_FLAGS}). Now tokenized into a bash array using xargs (with empty guard), then expanded as "${reviewdog_flags[@]}".
Both inputs are flag lists, so the xargs array approach is used rather than simple quoting, to correctly handle multi-argument values while preventing shell metacharacter injection.
The shebang was updated from #!/bin/sh to #!/bin/bash to support bash arrays and process substitution syntax.

