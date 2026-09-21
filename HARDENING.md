<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-yamllint/v1.21.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-yamllint/v1.21.0** was hardened automatically. 3 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile pipes a remotely fetched install script directly to `sh` without first saving it to disk for inspection. Pattern: `wget -O - -q https://raw.githubusercontent.com/.../install.sh| sh -s -- ...`. If the remote URL is ever compromised or the content changes, arbitrary code will execute in the build environment.

Locations:

- `Dockerfile:5`

### script-injection (severity: high)

Rule (a): A GitHub Actions expression `${{ github.repository }}` is interpolated directly inside a `run:` shell command string in dockerimage.yml. The offending line is: `run: docker build . --file Dockerfile --tag ${{ github.repository }}:$(date +%s)`. Any `${{ ... }}` expression inside a `run:` block undergoes YAML template substitution before the shell sees it, bypassing shell quoting and enabling injection.

Locations:

- `.github/workflows/dockerimage.yml:12`

### missing-permissions (severity: medium)

None of the four workflow files define a top-level `permissions:` block, and no job within any of these files defines its own `permissions:` block. Without explicit permissions, workflows run with the default (potentially broad) token permissions. All four files are affected: depup.yml, dockerimage.yml, release.yml, and reviewdog.yml.

Locations:

- `.github/workflows/depup.yml:1`
- `.github/workflows/dockerimage.yml:1`
- `.github/workflows/release.yml:1`
- `.github/workflows/reviewdog.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell, script-injection, missing-permissions

**Notes:**

1. Dockerfile: Replaced piped `wget | sh -s -- args` with a two-step approach: download to /tmp/install-reviewdog.sh, then execute with `sh /tmp/install-reviewdog.sh -b /usr/local/bin/ ${REVIEWDOG_VERSION}` (dropped `-s` and `--` per the rules since we're no longer reading from stdin), then remove the temp file. 2. dockerimage.yml: Moved `${{ github.repository }}` into an `env:` block as REPOSITORY and referenced it as `"${REPOSITORY}"` in the shell command to prevent script injection. Also added `permissions: {}`. 3. Added `permissions:` blocks to all four workflow files: dockerimage.yml gets `{}` (no special permissions needed), depup.yml gets `contents: write` + `pull-requests: write` (for creating PRs), release.yml gets `contents: write` (for creating releases/tags), reviewdog.yml gets `contents: read` + `checks: write` + `pull-requests: write` (for posting PR checks and reviews).

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed both unquoted shell variable expansions in entrypoint.sh:
1. Line 10: INPUT_YAMLLINT_FLAGS — tokenized into a bash array using xargs (quote-aware splitting), with a fallback to '.' when empty, then expanded as "${yamllint_flags[@]}".
2. Line 18: INPUT_REVIEWDOG_FLAGS — tokenized into a bash array using xargs, then expanded as "${reviewdog_flags[@]}".
Both inputs are argument lists (flag sets), so simple double-quoting would have collapsed them into single arguments. The xargs-based array approach correctly handles whitespace-separated flags and quoted sub-arguments while preventing shell metacharacter injection.

