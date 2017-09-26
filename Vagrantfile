# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

  # The vbguest plugin automatically installs the proper guest utils
  # vagrant plugin install vagrant-vbguest
  # https://github.com/dotless-de/vagrant-vbguest
  if Vagrant.has_plugin?("vbguest")
    config.vbguest.auto_update = true
    config.vbguest.iso_path = "http://download.virtualbox.org/virtualbox/%{version}/VBoxGuestAdditions_%{version}.iso"
  end

  # caching to speed-up box provisioning
  # vagrant plugin install vagrant-cachier
  # https://github.com/fgrehm/vagrant-cachier
  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
  end

  # provisioning stuff here
  config.vm.box = "ubuntu/xenial64"
  config.vm.define "testbox" do |node|
    node.vm.hostname = "testbox"
    node.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "3096"
    end
    node.vm.network "private_network", ip: "10.10.20.10"
    node.vm.synced_folder '.', '/vagrant'
    node.ssh.forward_agent = true
    node.ssh.insert_key = true
    # Remove all stdin is not a tty errors
    node.vm.provision "fix-no-tty", type: "shell" do |s|
      s.privileged = false
      s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
    end
    node.vm.provision :shell, :privileged => true, :path => "setup.sh"													        													
  end
end
