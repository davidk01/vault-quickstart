# Introduction

I got tired of repeating the same steps over and over again when setting up a vault server so
wrote a basic set of scripts to get up and running with a self-signed certificate and local
file backend.

The scripts are idempotent so it is possible to modify `vars.sh` and not rely on the defaults.
You can create the required files yourself and everything should still work fine.

For a more secure deployment I recommend encrypting the initialization data and not unsealing
the server automatically. The current initialization script (`init.sh`) stores the initialization data
in clear text and then uses that to unseal the running server (`unseal.sh`) after it is started
(`start.sh`). 

For a production deployment you'd probably also want to use a proper supervisor
script instead of `start.sh` which just uses `nohup`. Then again I'm not sure there is much
benefit to using a proper process supervisor. If the server dies you'd still need to unseal it
when it starts so it kinda defeats the purpose of running the server under a supervisor. You'd
still need to manually unseal the server and one extra step in the process is not going to make
much of a difference.

For an HA deployment you'd also want to use an HA backend like Consul. The current
configuration lives in `start.sh` and just configures a basic file backend based on
the parameters in `vars.sh`.

# Deployment

```
git clone https://github.com/davidk01/vault-quickstart.git
cd vault-quickstart
# We need the user that will run the vault process.
# If you have a user configured then change this to that user.
export VAULT_USER="$(whoami)"
./install.sh && ./start.sh && ./init.sh && ./unseal.sh
```

If you want to use the scripts as a cloud-init script then just cocatenate everything
together (`cat vars.sh install.sh start.sh init.sh unseal.sh`) and use that as the cloud-init
script.
