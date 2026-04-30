# Semaloop Submit Build

A Bitrise step that submits an iOS build to [Semaloop](https://semaloop.com) and enqueues tests against it.

## What it does

- Installs the latest [Semaloop CLI](https://github.com/semaloop/cli) release.
- Pushes a simulator `.app` build and/or a signed device `.ipa` build to Semaloop using `semaloop build push`.
- Authenticates with your Semaloop API key.

At least one of `app_path`, `test_bundle_path` or `ipa_path` must be provided.

## Inputs

| Key                | Description                                                                                                                         | Default                       | Required |
|--------------------|-------------------------------------------------------------------------------------------------------------------------------------|-------------------------------|----------|
| `api_key`          | Semaloop API key. Marked sensitive; store it as a secret env var on Bitrise.                                                        | `$SEMALOOP_API_KEY`           | Yes      |
| `app_path`         | Direct path to a simulator `.app` bundle. Takes precedence over `test_bundle_path`.                                                 | `$BITRISE_APP_PATH`           | No\*     |
| `test_bundle_path` | Directory to search for a simulator `.app` bundle (e.g. the output of the *Xcode Build for Testing* step). Ignored if `app_path` is set. | `$BITRISE_TEST_BUNDLE_PATH`   | No\*     |
| `ipa_path`         | Path to the signed `.ipa` file (produced by the *Xcode Archive & Export* step).                                                     | `$BITRISE_IPA_PATH`           | No\*     |

\* At least one of `app_path`, `test_bundle_path` or `ipa_path` is required.

## Example usage

In your `bitrise.yml`:

```yaml
- git::https://github.com/semaloop/bitrise-step-semaloop-submit-build.git@main:
    title: Submit build to Semaloop
    inputs:
    - api_key: $SEMALOOP_API_KEY
    - app_path: $BITRISE_APP_PATH
```

Or, when using the *Xcode Build for Testing* step (which outputs a directory rather than a `.app` directly):

```yaml
- git::https://github.com/semaloop/bitrise-step-semaloop-submit-build.git@main:
    title: Submit build to Semaloop
    inputs:
    - api_key: $SEMALOOP_API_KEY
    - test_bundle_path: $BITRISE_TEST_BUNDLE_PATH
```

Or, for a device build:

```yaml
- git::https://github.com/semaloop/bitrise-step-semaloop-submit-build.git@main:
    title: Submit build to Semaloop
    inputs:
    - api_key: $SEMALOOP_API_KEY
    - ipa_path: $BITRISE_IPA_PATH
```

## Local development

You can run this step directly with the [Bitrise CLI](https://github.com/bitrise-io/bitrise):

1. `git clone` this repository and `cd` into it.
2. Create a `.bitrise.secrets.yml` file alongside `bitrise.yml` (it's git-ignored) and set the required secrets:

    ```yaml
    envs:
    - SEMALOOP_API_KEY: your-api-key
    - BITRISE_APP_PATH: /path/to/build.app
    ```

3. Run the step:

    ```sh
    bitrise run test
    ```

## Contributing

1. Fork the repo and create a feature branch.
2. Make your changes to `step.sh` / `step.yml`.
3. Verify locally with `bitrise run test`.
4. Open a pull request.
