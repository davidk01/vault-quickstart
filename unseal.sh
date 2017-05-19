#!/bin/bash -eu
set -o pipefail
source ./vars.sh

# assuming default of 5 shares with 3 required to unseal
echo "Unsealing vault."
vault unseal -tls-skip-verify "$(cat "${VAULT_INIT_FILE}" | grep 'Key 1' | awk -F': ' '{print $2}')"
vault unseal -tls-skip-verify "$(cat "${VAULT_INIT_FILE}" | grep 'Key 2' | awk -F': ' '{print $2}')"
vault unseal -tls-skip-verify "$(cat "${VAULT_INIT_FILE}" | grep 'Key 3' | awk -F': ' '{print $2}')"
