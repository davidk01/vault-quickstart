#!/bin/bash -eu
set -o pipefail
export VAULT_URL="https://releases.hashicorp.com/vault/0.7.0/vault_0.7.0_linux_amd64.zip"
export VAULT_DOWNLOAD_TARGET="/tmp/vault.zip"
export VAULT_INSTALL_DIR="/usr/local/bin"
export VAULT_USER="${VAULT_USER:-}"
if [[ "x${VAULT_USER}" == "x" ]]; then
  echo "Specify vault user by setting 'VAULT_USER' environment variable."
  exit 1
fi
export VAULT_CONFIG_DIR="/etc/vault"
export VAULT_CONFIG_FILE="${VAULT_CONFIG_DIR}/vault.conf"
export VAULT_TLS_KEY="${VAULT_CONFIG_DIR}/vault.key"
export VAULT_TLS_CSR="${VAULT_CONFIG_DIR}/vault.csr"
export VAULT_TLS_CERT="${VAULT_CONFIG_DIR}/vault.cert"
export VAULT_DATA_FILE="${VAULT_CONFIG_DIR}/data"
export VAULT_LOG_FILE="${VAULT_CONFIG_DIR}/log"
export VAULT_INIT_FILE="${VAULT_CONFIG_DIR}/vault.init"
