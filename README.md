# Semaloop Submit Build

A Bitrise step that submits an iOS build to [Semaloop](https://semaloop.com) and enqueues tests against it.

## What it does

- Installs the [Semaloop CLI](https://github.com/semaloop/cli) (latest release by default, or a pinned version).
- Pushes a simulator `.app` build and/or a signed device `.ipa` build to Semaloop using `semaloop build push`.
- Authenticates with your Semaloop API key.

At least one of `app_path` or `ipa_path` must be provided.

## Inputs

| Key         | Description                                                                                  | Default                | Required |
|-------------|----------------------------------------------------------------------------------------------|------------------------|----------|
| `api_key`   | Semaloop API key. Marked sensitive; store it as a secret env var on Bitrise.                 | `$SEMALOOP_API_KEY`    | Yes      |
| `app_path`  | Path to the simulator `.app` build (produced by the *Xcode Build for Testing* step).         | `$BITRISE_APP_PATH`    | No\*     |
| `ipa_path`  | Path to the signed `.ipa` file (produced by the *Xcode Archive & Export* step).              | `$BITRISE_IPA_PATH`    | No\*     |
| `cli_version` | Version of the Semaloop CLI to install. Use `latest` or a specific release tag.            | `latest`               | No       |

\* At least one of `app_path` or `ipa_path` is required.

## Example usage

In your `bitrise.yml`:

```yaml
- git::https://github.com/semaloop/bitrise-step-semaloop-submit-build.git@main:
    title: Submit build to Semaloop
    inputs:
    - api_key: $SEMALOOP_API_KEY
    - app_path: $BITRISE_APP_PATH
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
