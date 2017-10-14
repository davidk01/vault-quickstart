#!/bin/bash -eu
set -o pipefail
source ./vars.sh

# assuming default of 5 shares with 3 required to unseal
echo "Unsealing vault."
vault unseal -tls-skip-verify "$(grep 'Key 1' "${VAULT_INIT_FILE}" | awk -F': ' '{print $2}')"
vault unseal -tls-skip-verify "$(grep 'Key 2' "${VAULT_INIT_FILE}" | awk -F': ' '{print $2}')"
vault unseal -tls-skip-verify "$(grep 'Key 3' "${VAULT_INIT_FILE}" | awk -F': ' '{print $2}')"
