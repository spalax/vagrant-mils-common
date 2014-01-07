Vagrant.configure("2") do |config|
  config.vm.box = "debian-wheezy72-x64-vbox43"
  config.vm.box_url = "http://box.puphpet.com/debian-wheezy72-x64-vbox43.box"

  config.vm.network "private_network", ip: "192.168.70.11"
  config.vm.hostname = "common.in"

  config.vm.synced_folder "./", "/var/www", id: "vagrant-root", :nfs => false

  config.vm.usable_port_range = (2200..2250)
  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.customize ["modifyvm", :id, "--name", "common-box"]
    virtualbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    virtualbox.customize ["modifyvm", :id, "--memory", "512"]
    virtualbox.customize ["setextradata", :id, "--VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end

  config.vm.provision :shell, :path => ".puppet/shell/initial-setup.sh"
  config.vm.provision :shell, :path => ".puppet/shell/update-puppet.sh"
  config.vm.provision :shell, :path => ".puppet/shell/librarian-puppet-vagrant.sh"
  config.vm.provision :puppet do |puppet|
    puppet.facter = {
      "ssh_username" => "vagrant"
    }

    puppet.manifests_path = ".puppet/puppet/manifests"
    puppet.module_path    = ".puppet/puppet/modules"
    puppet.options = ["--verbose", "--debug", "--hiera_config /vagrant/.puppet/hiera.yaml", "--parser future"]
  end

  config.ssh.username = "vagrant"
  config.ssh.shell = "bash -l"
  config.hostsupdater.remove_on_suspend = true
  config.ssh.keep_alive = true
  config.ssh.forward_agent = false
  config.ssh.forward_x11 = false
  config.vagrant.host = :detect
end

