<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-yamllint/v1.25.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-yamllint/v1.25.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The action.yml uses a Docker image reference with a mutable version tag instead of an immutable SHA digest. The image 'docker://ghcr.io/reviewdog/action-yamllint:v1.25.0' uses the tag 'v1.25.0', which can be silently replaced with different (potentially malicious) content. It should be pinned to a specific SHA256 digest, e.g. 'docker://ghcr.io/reviewdog/action-yamllint@sha256:<64-hex-char-digest> # v1.25.0'.

Locations:

- `action.yml:44`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned the Docker image reference in hardened/action/action.yml from 'docker://ghcr.io/reviewdog/action-yamllint:v1.25.0' to 'docker://ghcr.io/reviewdog/action-yamllint:v1.25.0@sha256:4906b4018f83c53b3eaabaa0be88fdd7dc970ebfd4d1b276cca0fe9267b3a32a', preserving the docker:// scheme and the tag inline alongside the immutable digest.

