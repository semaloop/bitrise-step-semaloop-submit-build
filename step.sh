#!/bin/bash
set -euo pipefail

# --- Validate inputs ---
if [ -z "${app_path:-}" ] && [ -z "${test_bundle_path:-}" ] && [ -z "${ipa_path:-}" ]; then
  echo "Error: at least one of app_path, test_bundle_path or ipa_path must be provided."
  exit 1
fi

# --- Resolve simulator .app from test bundle dir if needed ---
if [ -z "${app_path:-}" ] && [ -n "${test_bundle_path:-}" ]; then
  if [ ! -d "${test_bundle_path}" ]; then
    echo "Error: test_bundle_path '${test_bundle_path}' is not a directory."
    exit 1
  fi
  echo "Searching for .app inside: ${test_bundle_path}"
  app_path=$(find "${test_bundle_path}" -name "*.app" -not -path "*.xctest*" -type d | head -1)
  if [ -z "${app_path}" ]; then
    echo "Error: no .app bundle found inside '${test_bundle_path}'."
    exit 1
  fi
fi

# --- Install CLI ---
echo "Installing Semaloop CLI (latest)..."
INSTALL_DIR="$(mktemp -d)"

DOWNLOAD_URL=$(curl -sf https://api.github.com/repos/semaloop/cli/releases/latest \
  | grep "browser_download_url" \
  | grep -i "Darwin_arm64" \
  | cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
  echo "Error: could not resolve Semaloop CLI download URL."
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