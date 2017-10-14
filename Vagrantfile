# Where we will put the working directory
shared_folder = "/vagrant".freeze
# Where will vault server listen
vault_port = 8200

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: vault_port, host: vault_port
  config.vm.synced_folder "./", shared_folder
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
    vb.cpus = 2
  end
  config.vm.provision "shell", inline: <<-SHELL
    set -euo pipefail
    export VAULT_USER=vault
    pushd #{shared_folder}
      ./install.sh
      ./start.sh
      ./init.sh
      ./unseal.sh
    popd
  SHELL
end
