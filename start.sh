#!/bin/bash -eu
set -o pipefail
source ./vars.sh

# start if not running
if ! (ps aux | grep [v]ault); then
  vault_binary="$(which vault)"
  nohup sudo su "${VAULT_USER}" -c "${vault_binary} server -config \"${VAULT_CONFIG_FILE}\"" &> "${VAULT_LOG_FILE}" &
  sleep 5
  cat "${VAULT_LOG_FILE}"
  ps aux | grep [v]ault
fi
