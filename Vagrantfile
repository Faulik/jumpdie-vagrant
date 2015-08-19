# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
PROJECT_NAME = "Jumpdie"
DEFAULT_USER = "vagrant"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  #config.vm.box = "ericmann/trusty64"
  # for virtualbox 
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "vagrant.dev.box"

  # config.vm.provider :hyperv do | v |
  #     v.ip_address_timeout = 240
  #     v.vmname = "vagrant.dev.box"
  #     v.cpus = 2
  #     v.memory = 1024
  # end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false
  
  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  #config.vm.network "forwarded_port", guest: 8080, host: 1234

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.2.44"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  config.vm.network "public_network", ip: "192.168.2.44"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  #backend dir
  config.vm.synced_folder "./backend", "/home/" + DEFAULT_USER + "/" + PROJECT_NAME + "/backend", type: "smb", smb_password: "vagrant1", smb_username: "vagrant"

  #frontend dir
  config.vm.synced_folder "./frontend", "/home/" + DEFAULT_USER + "/" + PROJECT_NAME + "/frontend", type: "smb", smb_password: "vagrant1", smb_username: "vagrant"

  #Hiera things
  config.vm.synced_folder "puppet/configuration", "/tmp/vagrant-puppet/configuration", type: "smb", smb_password: "vagrant1", smb_username: "vagrant" #,owner: "varant", group: "vagrant"

  #Install puppet
  config.vm.provision :shell do |shell|
    shell.path = "puppet/shell/install-puppet.sh"
  end

  #Use puppet
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.manifest_file  = 'init.pp'
    puppet.module_path = ["puppet/modules"]
    puppet.hiera_config_path = "puppet/hiera.yaml"
    puppet.working_directory = "/tmp/vagrant-puppet"

    puppet.options = "--verbose"
    
    puppet.facter = {
      'project_name' => PROJECT_NAME,
      'default_user' => DEFAULT_USER
    }
  end


end
