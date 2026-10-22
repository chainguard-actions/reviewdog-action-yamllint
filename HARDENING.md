<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-yamllint/v1.25.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-yamllint/v1.25.3** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

action.yml runs.image points to a mutable tag instead of a SHA256 digest: `image: 'docker://ghcr.io/reviewdog/action-yamllint:v1.25.3'`. Pin it to a digest, e.g. ghcr.io/reviewdog/action-yamllint@sha256:<digest> # v1.25.3.

Locations:

- `action.yml:44`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned runs.image to docker://ghcr.io/reviewdog/action-yamllint:v1.25.3@sha256:c5865666493df7910d907d4b2305dc86430223dd23675a21c8e29976872d8117.

