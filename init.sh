#!/bin/bash -eu
set -o pipefail
source ./vars.sh

if [[ -e "${VAULT_INIT_FILE}" ]]; then
  echo "Vault initialization file exists so assuming already initialized."
  cat "${VAULT_INIT_FILE}"
  exit 0
fi
vault init -tls-skip-verify &> "${VAULT_INIT_FILE}"
