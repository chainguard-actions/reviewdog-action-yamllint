# GitHub Action: Run yamllint with reviewdog

[![Docker Image CI](https://github.com/reviewdog/action-yamllint/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/reviewdog/action-yamllint/actions)
[![Release](https://img.shields.io/github/release/reviewdog/action-yamllint.svg?maxAge=43200)](https://github.com/reviewdog/action-yamllint/releases)

This action runs [yamllint](https://github.com/adrienverge/yamllint) with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve
code review experience.

[![github-pr-check sample](https://user-images.githubusercontent.com/8191198/72208542-0ddba200-34a4-11ea-90ce-c9508942420c.png)](https://github.com/reviewdog/action-yamllint/pull/1)
[![github-pr-review sample](https://user-images.githubusercontent.com/8191198/72208536-087e5780-34a4-11ea-8ac7-bc7161c9cc20.png)](https://github.com/reviewdog/action-yamllint/pull/1)

## Inputs

### `github_token`

Optional. `${{ github.token }}` is used by default.

### `level`

Optional. Report level for reviewdog [info,warning,error].
It's same as `-level` flag of reviewdog.

### `reporter`

Reporter of reviewdog command [github-pr-check,github-check,github-pr-review].
Default is github-pr-check.
It's same as `-reporter` flag of reviewdog.

github-pr-review can use Markdown and add a link to rule page in reviewdog reports.

### `filter_mode`

Optional. Filtering mode for the reviewdog command [added,diff_context,file,nofilter]. Default is added.

### `fail_level`

Optional. If set to `none`, always use exit code 0 for reviewdog.
Otherwise, exit code 1 for reviewdog if it finds at least 1 issue with severity greater than or equal to the given level.
Possible values: [`none`, `any`, `info`, `warning`, `error`]
Default is `none`.

### `fail_on_error`

Deprecated, use `fail_level` instead.
Optional. Exit code for reviewdog when errors are found [true,false] Default is `false`.

### `reviewdog_flags`

Optional. Additional reviewdog flags.

### `yamllint_flags`

Optional. Flags and args of yamllint command. Default: '.'

## Example usage

You can create [yamllint
config](https://yamllint.readthedocs.io/en/stable/configuration.html)
and this action uses that config too.

### [.github/workflows/reviewdog.yml](.github/workflows/reviewdog.yml)

```yml
name: reviewdog
on: [pull_request]
jobs:
  yamllint:
    name: runner / yamllint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: yamllint
        uses: reviewdog/action-yamllint@v1
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-review # Change reporter.
          yamllint_flags: 'src/'
```

## Privacy

This Action contacts Chainguard's licensing server to verify authorization. Connection metadata (IP address, GitHub repository identifier, timestamp, and any metadata encoded in the auth token) is transmitted to Chainguard, Inc. even if authorization is denied in accordance with our [Privacy Notice](https://www.chainguard.dev/legal/privacy-notice)
