#!/bin/bash

cd "$GITHUB_WORKSPACE" || exit

git config --global --add safe.directory $GITHUB_WORKSPACE

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo '::group:: Running yamllint with reviewdog 🐶 ...'
yamllint --version

yamllint_flags=()
if [ -n "${INPUT_YAMLLINT_FLAGS}" ]; then
  while IFS= read -r -d '' t; do yamllint_flags+=("$t"); done \
    < <(printf '%s' "${INPUT_YAMLLINT_FLAGS}" | xargs printf '%s\0')
else
  yamllint_flags=('.')
fi

reviewdog_flags=()
if [ -n "${INPUT_REVIEWDOG_FLAGS}" ]; then
  while IFS= read -r -d '' t; do reviewdog_flags+=("$t"); done \
    < <(printf '%s' "${INPUT_REVIEWDOG_FLAGS}" | xargs printf '%s\0')
fi

yamllint --format "parsable" "${yamllint_flags[@]}" |
    reviewdog \
        -efm="%f:%l:%c: %m" \
        -name "yamllint" \
        -reporter="${INPUT_REPORTER:-github-pr-check}" \
        -level="${INPUT_LEVEL}" \
        -filter-mode="${INPUT_FILTER_MODE}" \
        -fail-level="${INPUT_FAIL_LEVEL}" \
        -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
        "${reviewdog_flags[@]}"
EXIT_CODE=$?
echo '::endgroup::'

exit $EXIT_CODE
