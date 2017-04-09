#!/bin/bash -eu
set -o pipefail
source ./vars.sh

# start if not running
if ! (ps aux | grep [v]ault &> /dev/null); then
  nohup sudo su "${VAULT_USER}" -c "vault server -config \"${VAULT_CONFIG_FILE}\"" &> "${VAULT_LOG_FILE}" &
fi
