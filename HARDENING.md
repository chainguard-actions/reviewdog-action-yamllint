<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-yamllint/v1.24.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-yamllint/v1.24.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The action uses `runs.using: docker` with a mutable image tag instead of a SHA digest. The `image:` field references `docker://ghcr.io/reviewdog/action-yamllint:v1.24.0`, which is a version tag that can be silently redirected to a different (potentially malicious) image. It should be pinned to an immutable SHA digest, e.g. `docker://ghcr.io/reviewdog/action-yamllint@sha256:<64-hex-char-digest>`.

Locations:

- `action.yml:45`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned the Docker container image in action.yml from the mutable tag `docker://ghcr.io/reviewdog/action-yamllint:v1.24.0` to the immutable digest `docker://ghcr.io/reviewdog/action-yamllint:v1.24.0@sha256:9467c8167c94d2fab745fc8b8c5f24c520f8155fb6972401032c13869ec568bc`. The `docker://` scheme and version tag are preserved inline alongside the digest.

