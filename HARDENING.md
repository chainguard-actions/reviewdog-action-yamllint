<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-yamllint/v1.25.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-yamllint/v1.25.4** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

action.yml is a Docker action whose runs.image uses a mutable tag instead of a SHA digest: `image: 'docker://ghcr.io/reviewdog/action-yamllint:v1.25.4'`. Pin it to a digest, e.g. `docker://ghcr.io/reviewdog/action-yamllint@sha256:<digest> # v1.25.4`.

Locations:

- `action.yml:44`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned runs.image to docker://ghcr.io/reviewdog/action-yamllint:v1.25.4@sha256:5677c9275a40dffb736844c13e1e7e2279eba4cecf203ca819805b4a57161cd7

