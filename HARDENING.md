<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-yamllint/v1.25.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-yamllint/v1.25.1** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The action.yml uses a Docker image referenced by a mutable tag (`v1.25.1`) instead of an immutable SHA digest. This means the image could be silently replaced with a different (potentially malicious) version. The failing reference is: `image: 'docker://ghcr.io/reviewdog/action-yamllint:v1.25.1'`. It should be pinned to a SHA digest, e.g. `image: 'docker://ghcr.io/reviewdog/action-yamllint@sha256:<64-hex-char-digest>'`.

Locations:

- `action.yml:44`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned the Docker image reference in action.yml from 'docker://ghcr.io/reviewdog/action-yamllint:v1.25.1' to 'docker://ghcr.io/reviewdog/action-yamllint:v1.25.1@sha256:bd790f0101ab86341089d13c8dc2507b560ee467505d7779cded92eb6b08156a', preserving the docker:// scheme and version tag while adding the immutable SHA digest.

