<p align="center">
  <a href="https://sentry.io" target="_blank" align="center">
    <img src="https://sentry-brand.storage.googleapis.com/sentry-logo-black.png" width="280">
  </a>
  <br />
</p>

# Contributing

We welcome suggested improvements and bug fixes for `sentry-fastlane-plugin`, in the form of pull requests. To get early feedback, we recommend opening up a [draft PR](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests#draft-pull-requests). Please follow our official [Commit Guidelines](https://develop.sentry.dev/code-review/#commit-guidelines) and also prefix the title of your PR according to the [Commit Guidelines](https://develop.sentry.dev/code-review/#commit-guidelines). The guide below will help you get started, but if you have further questions, please feel free to reach out on [Discord](https://discord.gg/Ww9hbqr).

## Environment

Make sure you have Ruby (>= 3.1.0) and [Bundler](https://bundler.io/) installed. Then run:

```sh
bundle install
```

This will install all dependencies, including `fastlane`, `rspec`, and `rubocop`.

You will also need [Homebrew](https://brew.sh/) to install additional tooling defined in the `Brewfile`:

```sh
brew bundle
```

## Running Tests

Tests are written with [RSpec](https://rspec.info/) and live in the `spec/` directory. To run the full test suite:

```sh
bundle exec rspec
```

To run a specific test file:

```sh
bundle exec rspec spec/sentry_helper_spec.rb
```

## Code Formatting

We use [dprint](https://dprint.dev/) for formatting JSON, Markdown, and YAML files. The configuration is in [`dprint.json`](./dprint.json). To check formatting:

```sh
dprint check
```

To auto-format:

```sh
dprint fmt
```

## Linting

We use [RuboCop](https://rubocop.org/) for Ruby linting. To run the linter:

```sh
bundle exec rubocop
```

## PR Reviews

### PR Status and Readiness

- **Pull requests which are not ready for review should stay in draft mode.** Use GitHub's draft PR feature to indicate that your PR is still work in progress and not yet ready for maintainer review.
- **Pull requests which are ready to review should be marked as such.** When your PR is ready for review, mark it as ready by converting it from draft to a regular PR.

### Review Types and Meanings

For feedback in PRs, we use the [LOGAF scale](https://develop.sentry.dev/engineering-practices/code-review/#logaf-scale) to specify how important a comment is. You only need one approval from a maintainer to be able to merge. For some PRs, asking specific or multiple people for review might be adequate.

**Understanding review feedback:**

- **PR comments are a request for change.** When a reviewer leaves comments on your PR, they are requesting changes or asking questions that need to be addressed.
- **PR approvals are a confirmation it can be merged.** An approval indicates the reviewer has reviewed your PR and confirms it's ready to be merged.

Our different types of reviews:

1. **LGTM without any comments.** You can merge immediately.
2. **LGTM with low and medium comments.** The reviewer trusts you to resolve these comments yourself, and you don't need to wait for another approval.
3. **Only comments.** You must address all the comments and need another review until you merge.
4. **Request changes.** Only use if something critical is in the PR that absolutely must be addressed. We usually use `h` comments for that. When someone requests changes, the same person must approve the changes to allow merging. Use this sparingly.

**Comment resolution workflow:**

- `h` (high) comments **must be resolved by the reviewer** who left them — the author should not self-resolve these.
- `m` (medium) and `l` (low) comments may be resolved by the PR author once they believe the concern has been appropriately addressed.

### After Addressing PR Feedback

**After addressing PR feedback, request another PR review via GitHub.** This changes the pull request status back from commented/approved to waiting, ensuring maintainers are notified that you've addressed their feedback and the PR is ready for re-review.

## Changelog Entries and Linked Issues

Changelog entries are generated from merged PRs (see Danger and release tooling). If a PR should
trigger a comment on a linked issue after a release ships, use a GitHub closing keyword in the PR
description, such as `Fixes #123`, `Closes #123`, or `Resolves #123`. The release notification
workflow only comments on issues GitHub recognizes as closed by the released PR; mentioning an issue
without a closing keyword is not enough.

## AI Use

You are welcome to use whatever tools you prefer for making a contribution. However, any changes you propose have to be reviewed and tested by you, a human, first, before you submit a pull request with them for the Sentry team to review. If we feel like that didn't happen, we will close the PR outright. For example, we won't review visibly AI-generated PRs from an agent instructed to look for and "fix" open issues in the repo. This aligns with our SDK principle: [every line has an owner](https://develop.sentry.dev/sdk/getting-started/principles/#every-line-has-an-owner).

## Final Notes

When contributing to the codebase, please make note of the following:

- Non-trivial PRs will not be accepted without tests (see above).
- Please do not bump version numbers yourself.
