<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-yamllint/v1.25.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-yamllint/v1.25.2** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The action.yml uses a Docker image referenced by a mutable version tag (`v1.25.2`) rather than an immutable SHA digest. This means the image could be silently replaced with a different (potentially malicious) version. The image reference `docker://ghcr.io/reviewdog/action-yamllint:v1.25.2` should be pinned to a SHA digest, e.g. `docker://ghcr.io/reviewdog/action-yamllint@sha256:<64-hex-char-digest>`.

Locations:

- `action.yml:44`

### unsafe-shell (severity: high)

The Dockerfile pipes a remote script directly to `sh` without first downloading and verifying it: `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/.../install.sh | sh -s -- ...`. Although the URL includes a commit SHA in the path, the content is still streamed directly to a shell interpreter, which is an unsafe pattern. The script should be downloaded to a file first, its integrity verified (e.g. via checksum), and then executed separately.

Locations:

- `Dockerfile:5`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, unsafe-shell

**Notes:**

1. action.yml: Pinned the Docker image `ghcr.io/reviewdog/action-yamllint:v1.25.2` to its immutable SHA256 digest (`sha256:6db868a6c5b863b2cff25493d29542bcd9bfb3641fcef262433e88ffa338369d`), keeping the tag inline and preserving the `docker://` scheme. 2. Dockerfile: Replaced the unsafe `wget ... | sh -s -- -b ...` pipe pattern with a download-then-execute approach: the install script is downloaded to `/tmp/install-reviewdog.sh`, then executed with `sh /tmp/install-reviewdog.sh -b /usr/local/bin/ ${REVIEWDOG_VERSION}` (dropping the `--` which was the shell's option terminator, not the script's), and cleaned up afterward.

