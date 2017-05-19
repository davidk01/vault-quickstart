#!/bin/bash -eu 
set -o pipefail
source ./vars.sh

# we need wget
if ! (which wget); then
  (sudo yum install -y wget) || \
    (sudo apt-get install --yes --force-yes wget) || \
    echo "Failed to install wget!"
fi
# make sure we actually have it
which wget > /dev/null

# if we do not have it then download and unpack into place
if ! (vault -v); then
  # grab the zip file for the binary
  if [[ ! -e "${VAULT_DOWNLOAD_TARGET}" ]]; then
    wget -O "${VAULT_DOWNLOAD_TARGET}" "${VAULT_URL}"
  fi
  unzip -d "${VAULT_INSTALL_DIR}" "${VAULT_DOWNLOAD_TARGET}"
fi

# make sure we actually got it
hash -r
if ! (vault -v); then
  if ! (echo $PATH | grep "${VAULT_INSTALL_DIR}"); then
    first_path_component="$(echo $PATH | cut -d: -f1)"
    echo "Vault was installed into a directory that is not in the path."
    echo "Symlinking it into the first path component: ${first_path_component}."
    sudo ln -sf "${VAULT_INSTALL_DIR}/vault" "${first_path_component}/vault"
    hash -r
  fi
fi

# set mlock capability so we can run process as non-root user
sudo setcap cap_ipc_lock=+ep $(readlink -f $(which vault)) || true

# configuration directory
if [[ ! -e "${VAULT_CONFIG_DIR}" ]]; then
  sudo mkdir -p "${VAULT_CONFIG_DIR}"
fi
sudo chown -R "${VAULT_USER}:${VAULT_USER}" "${VAULT_CONFIG_DIR}"

# key and certificate signing request for TLS
if [[ ! -e "${VAULT_TLS_KEY}" ]]; then
  openssl req -nodes -newkey rsa:2048 \
    -keyout "${VAULT_TLS_KEY}" \
    -out "${VAULT_TLS_CSR}" \
    -subj "/C=''/ST=''/L=''/O=''/OU=''/CN=''"
fi

# self-signed certificate for TLS
if [[ ! -e "${VAULT_TLS_CERT}" ]]; then
  openssl x509 -req \
    -in "${VAULT_TLS_CSR}" \
    -out "${VAULT_TLS_CERT}" \
    -signkey "${VAULT_TLS_KEY}" \
    -days 1000
fi

# basic configuration
cat << EOF > "${VAULT_CONFIG_FILE}"
storage "file" {
  path = "${VAULT_DATA_FILE}"
}
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_cert_file = "${VAULT_TLS_CERT}"
  tls_key_file = "${VAULT_TLS_KEY}"
}
EOF
