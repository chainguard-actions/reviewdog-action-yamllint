<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-yamllint/v1.20.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **reviewdog--action-yamllint/v1.20.1** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile downloads and pipes a remote install script directly to `sh` without first saving it to a file: `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}`. This allows a compromised or man-in-the-middle remote resource to execute arbitrary code during the Docker image build.

Locations:

- `Dockerfile:5`

### script-injection (severity: high)

Sub-rule (b): In entrypoint.sh, two user-controlled input variables are expanded without double-quoting, allowing shell metacharacter injection. (1) `${INPUT_YAMLLINT_FLAGS:-'.'}` is passed unquoted to `yamllint`, where a value containing spaces, semicolons, or other shell metacharacters would be word-split and interpreted by the shell. (2) `${INPUT_REVIEWDOG_FLAGS}` is passed unquoted to `reviewdog`, with the same risk. Both variables are sourced from action inputs (`inputs.yamllint_flags` and `inputs.reviewdog_flags`) which are workflow-controllable and must be double-quoted.

Locations:

- `entrypoint.sh:9`
- `entrypoint.sh:18`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell, script-injection

**Notes:**

1. Dockerfile: Replaced `wget -O - -q ... | sh -s` pipe pattern with a two-step approach: download the install script to /tmp/install-reviewdog.sh, execute it with `sh`, then remove it. This prevents arbitrary code execution from a compromised remote resource during image build.
2. entrypoint.sh: Added double-quotes around `${INPUT_YAMLLINT_FLAGS:-'.'}` (line 9) and `${INPUT_REVIEWDOG_FLAGS}` (line 18) to prevent word-splitting and shell metacharacter injection from user-controlled action inputs.

