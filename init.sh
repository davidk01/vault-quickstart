#!/bin/bash -eu
set -o pipefail
source ./vars.sh

vault init -tls-skip-verify &> "${VAULT_INIT_FILE}" || true
echo "Dumping init log file."
cat "${VAULT_INIT_FILE}"
