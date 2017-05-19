#!/bin/bash -eu
set -o pipefail
source ./vars.sh

if ! (grep 'Initial Root Token' "${VAULT_INIT_FILE}"); then
  vault init -tls-skip-verify &> "${VAULT_INIT_FILE}"
  echo "Dumping init log file."
  cat "${VAULT_INIT_FILE}"
fi
