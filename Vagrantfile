# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE = "bento/centos-8.1"

Vagrant.configure("2") do |config|

  config.vm.box = BOX_IMAGE

  config.vm.define "frontend" do |node|
    node.vm.hostname = "frontend.local"
    node.vm.network "private_network", ip: "192.168.10.100"
    node.vm.provision :shell, path: "scripts/fe-config.sh", privileged: true
    node.vm.provider "virtualbox" do |v|
      v.name = "frontend"
    end
  end

  config.vm.define "backend" do |node|
    node.vm.hostname = "backend.local"
    node.vm.network "private_network", ip: "192.168.10.101"
    node.vm.provision :shell, path: "scripts/be-config.sh", privileged: true
    node.vm.provider "virtualbox" do |v|
      v.name = "bakend"
    end
  end

  #config.vm.define "database" do |node|
  #  node.vm.hostname = "database.local"
  #  node.vm.network "private_network", ip: "192.168.10.102"
  #  node.vm.provider "virtualbox" do |v|
  #    v.name = "database"
  #  end
  #end

end
