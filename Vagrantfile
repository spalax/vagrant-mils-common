# -*- mode: ruby -*-
# vi: set ft=ruby :

require './.Vagrantfilerc.rb'
include MyLocalVars

Vagrant.configure("2") do |config|
  config.vm.box = "debian-wheezy72-x64-vbox43"
  config.vm.box_url = "http://box.puphpet.com/debian-wheezy72-x64-vbox43.box"

  config.vm.network "private_network", ip: MY_IP
  if MY_PUBLIC_NETWORK_ENABLED
    config.vm.network "public_network", :bridge => 'en0: Wi-Fi (AirPort)'
  end
  
  config.vm.hostname = MY_HOSTNAME
  if MY_HOST_ALIASES
     config.hostsupdater.aliases = MY_HOST_ALIASES
  end

  config.vm.synced_folder "./", "/var/www", id: "vagrant-root", :nfs => true, :map_uid => 0, :map_gid => 0

  config.vm.usable_port_range = (2200..2250)
  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.customize ["modifyvm", :id, "--name", MY_VBOX_NAME]
    virtualbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    if MY_VBOX_MEMORY >= 512
      virtualbox.customize ["modifyvm", :id, "--memory", MY_VBOX_MEMORY]
    else
      virtualbox.customize ["modifyvm", :id, "--memory", "512"]
    end
    virtualbox.customize ["modifyvm", :id, "--cpus", `awk "/^processor/ {++n} END {print n}" /proc/cpuinfo 2> /dev/null || sh -c 'sysctl hw.logicalcpu 2> /dev/null || echo ": 2"' | awk \'{print \$2}\' `.chomp ]
    virtualbox.customize ["setextradata", :id, "--VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end

  config.vm.provision :shell, :path => ".puppet/shell/initial-setup.sh"
  config.vm.provision :shell, :path => ".puppet/shell/update-puppet.sh"
  config.vm.provision :shell, :path => ".puppet/shell/librarian-puppet-vagrant.sh"
  config.vm.provision :puppet do |puppet|
    puppet.facter = {
      "ssh_username" => "vagrant"
    }

    if MY_HOST_ALIASES
       puppet.facter['aliases'] = 1
    end

    puppet.manifests_path = ".puppet/puppet/manifests"
    puppet.module_path    = ".puppet/puppet/modules"
    puppet.options = ["--verbose", "--hiera_config /vagrant/.puppet/hiera.yaml", "--parser future"]
  end

  config.ssh.username = "vagrant"
  config.ssh.shell = "bash -l"
  config.hostsupdater.remove_on_suspend = true
  config.ssh.keep_alive = true
  config.ssh.forward_agent = false
  config.ssh.forward_x11 = false
  config.vagrant.host = :detect
end

