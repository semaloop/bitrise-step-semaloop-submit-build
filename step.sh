#!/bin/bash
set -euo pipefail

# --- Validate inputs ---
if [ -z "${app_path:-}" ] && [ -z "${ipa_path:-}" ]; then
  echo "Error: at least one of app_path or ipa_path must be provided."
  exit 1
fi

# --- Install CLI ---
cli_version="${cli_version:-latest}"
echo "Installing Semaloop CLI (${cli_version})..."
INSTALL_DIR="$(mktemp -d)"

if [ "$cli_version" = "latest" ]; then
  DOWNLOAD_URL=$(curl -sf https://api.github.com/repos/semaloop/cli/releases/latest \
    | grep "browser_download_url" \
    | grep -i "Darwin_arm64" \
    | cut -d '"' -f 4)
else
  DOWNLOAD_URL="https://github.com/semaloop/cli/releases/download/${cli_version}/cli_Darwin_arm64.tar.gz"
fi

if [ -z "$DOWNLOAD_URL" ]; then
  echo "Error: could not resolve Semaloop CLI download URL for version '${cli_version}'."
  exit 1
fi

curl -fsSL "$DOWNLOAD_URL" | tar -xz -C "$INSTALL_DIR"
export PATH="$INSTALL_DIR:$PATH"

# --- Push simulator build ---
if [ -n "${app_path:-}" ]; then
  echo "Pushing simulator build: ${app_path}"
  SEMALOOP_API_KEY="${api_key}" semaloop build push "${app_path}"
fi

# --- Push device build (once CLI supports it) ---
if [ -n "${ipa_path:-}" ]; then
  echo "Pushing device build: ${ipa_path}"
  SEMALOOP_API_KEY="${api_key}" semaloop build push "${ipa_path}"
fi