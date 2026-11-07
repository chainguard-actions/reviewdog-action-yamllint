<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-yamllint/v1.26.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-yamllint/v1.26.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The Docker action's runs.image uses a changeable tag instead of a SHA digest: `image: 'docker://ghcr.io/reviewdog/action-yamllint:v1.26.0'`. Whoever controls the registry can re-point the tag to a different image. Pin it to a digest, e.g. `docker://ghcr.io/reviewdog/action-yamllint@sha256:<digest> # v1.26.0`.

Locations:

- `action.yml:45`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned runs.image in action.yml to docker://ghcr.io/reviewdog/action-yamllint:v1.26.0@sha256:7f7bc22abc4663f20ec95bb388c7340abda0f0bb0bf24e7cb42c815be3179d1f.

