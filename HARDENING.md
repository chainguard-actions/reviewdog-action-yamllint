<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-yamllint/v1.20.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-yamllint/v1.20.0** was hardened automatically. 3 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

All `uses:` references in workflow files use mutable tags or version strings instead of full 40-character SHA commit pins. This exposes the action to supply-chain attacks if any referenced action is compromised or its tag is moved. Failing references:
- depup.yml: `actions/checkout@v4`, `haya14busa/action-depup@v1`, `peter-evans/create-pull-request@v6`
- dockerimage.yml: `actions/checkout@v4`
- release.yml: `actions/checkout@v4`, `haya14busa/action-bumpr@v1`, `haya14busa/action-update-semver@v1`, `haya14busa/action-cond@v1` (×2 jobs)
- reviewdog.yml: `actions/checkout@v4`

Locations:

- `.github/workflows/depup.yml:13`
- `.github/workflows/depup.yml:14`
- `.github/workflows/depup.yml:21`
- `.github/workflows/dockerimage.yml:11`
- `.github/workflows/release.yml:17`
- `.github/workflows/release.yml:23`
- `.github/workflows/release.yml:27`
- `.github/workflows/release.yml:32`
- `.github/workflows/release.yml:46`
- `.github/workflows/release.yml:48`
- `.github/workflows/reviewdog.yml:7`

### script-injection (severity: high)

Sub-rule (a): A GitHub Actions expression is interpolated directly inside a `run:` shell command string. In dockerimage.yml, the `run:` block contains `${{ github.repository }}` which is substituted into the shell command before execution. Although `github.repository` is not directly attacker-controlled via PR, any `${{ ... }}` expression inside a `run:` block is a script-injection risk because the value flows through YAML template substitution before the shell ever sees it. Offending line: `run: docker build . --file Dockerfile --tag ${{ github.repository }}:$(date +%s)`

Locations:

- `.github/workflows/dockerimage.yml:13`

### missing-permissions (severity: medium)

None of the four workflow files define a top-level `permissions:` key, and no individual job within any of these files defines a `permissions:` key either. Without explicit permissions, workflows run with the default repository permissions (which may be `write` for contents and other scopes), granting broader access than necessary. All four workflow files are affected: depup.yml, dockerimage.yml, release.yml, and reviewdog.yml.

Locations:

- `.github/workflows/depup.yml:1`
- `.github/workflows/dockerimage.yml:1`
- `.github/workflows/release.yml:1`
- `.github/workflows/reviewdog.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, script-injection, missing-permissions

**Notes:**

Fixed all three finding types across four workflow files:

1. unpinned-uses: Pinned all 6 unique action references to full 40-char SHAs with original tag as comment. actions/checkout@v4→34e114876b0b11c390a56381ad16ebd13914f8d5, haya14busa/action-depup@v1→99f7aecf3e4d06d5a3faf190dae5dc79ac530b5a, peter-evans/create-pull-request@v6→c5a7806660adbe173f04e3e038b0ccdcd758773c, haya14busa/action-bumpr@v1→faf6f474bcb6174125cfc569f0b2e24cbf03d496, haya14busa/action-update-semver@v1→7d2c558640ea49e798d46539536190aff8c18715, haya14busa/action-cond@v1→94f77f7a80cd666cb3155084e428254fea4281fd.

2. script-injection: In dockerimage.yml, moved ${{ github.repository }} from the run: shell string into an env: block as REPOSITORY, then referenced it as "$REPOSITORY" in the shell command.

3. missing-permissions: Added top-level permissions blocks to all four files with minimal required scopes: depup.yml (contents:write, pull-requests:write), dockerimage.yml (contents:read), release.yml (contents:write, pull-requests:write), reviewdog.yml (contents:read, pull-requests:write, checks:write).

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed two unquoted variable expansions in hardened/action/entrypoint.sh: (1) Line 10: changed `${INPUT_YAMLLINT_FLAGS:-'.'}` to `"${INPUT_YAMLLINT_FLAGS:-.}"` — added double quotes and simplified the default value syntax. (2) Line 18: changed `${INPUT_REVIEWDOG_FLAGS}` to `"${INPUT_REVIEWDOG_FLAGS}"` — added double quotes. Both variables are now properly quoted, preventing shell metacharacter injection from attacker-controlled action inputs.

