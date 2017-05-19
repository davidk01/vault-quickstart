#!/bin/bash -eu
set -o pipefail
source ./vars.sh

# start if not running
vault_binary="$(which vault)"
if ! (ps aux | grep "${vault_binary}" | grep -v grep); then
  nohup sudo su "${VAULT_USER}" -c "${vault_binary} server -config \"${VAULT_CONFIG_FILE}\"" &> "${VAULT_LOG_FILE}" &
  echo "Waiting for vault server to start."
  sleep 5
  echo "Dumping server log file."
  cat "${VAULT_LOG_FILE}"
fi
