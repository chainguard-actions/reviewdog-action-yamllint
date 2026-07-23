#!/bin/sh

cd "$GITHUB_WORKSPACE" || exit

git config --global --add safe.directory "$GITHUB_WORKSPACE"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo '::group:: Running yamllint with reviewdog 🐶 ...'
yamllint --version

# Disable glob expansion to prevent glob injection from flag variables,
# then restore it after the command. Word-splitting is intentional here
# so that multi-word flag strings (e.g. "-d relaxed .") are split correctly.
set -f
# shellcheck disable=SC2086
yamllint --format "parsable" ${INPUT_YAMLLINT_FLAGS:-'.'} |
    reviewdog \
        -efm="%f:%l:%c: %m" \
        -name "yamllint" \
        -reporter="${INPUT_REPORTER:-github-pr-check}" \
        -level="${INPUT_LEVEL}" \
        -filter-mode="${INPUT_FILTER_MODE}" \
        -fail-level="${INPUT_FAIL_LEVEL}" \
        -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
        ${INPUT_REVIEWDOG_FLAGS}
EXIT_CODE=$?
set +f
echo '::endgroup::'

exit $EXIT_CODE
