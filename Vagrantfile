# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE = "bento/centos-8.1"

Vagrant.configure("2") do |config|

  config.vm.box = BOX_IMAGE

  config.vm.define "frontend" do |fe|
    fe.vm.hostname = "frontend.local"
    fe.vm.network "private_network", ip: "192.168.10.100"
    fe.vm.provision :shell, path: "scripts/bootstrap.sh", privileged: true
    fe.vm.provision :shell, path: "scripts/fe-config.sh", privileged: true
    fe.vm.provider "virtualbox" do |v|
      v.name = "frontend"
    end
  end

  config.vm.define "backend" do |be|
    be.vm.hostname = "backend.local"
    be.vm.network "private_network", ip: "192.168.10.101"
    be.vm.provision :shell, path: "scripts/bootstrap.sh", privileged: true
    be.vm.provision :shell, path: "scripts/be-config.sh", privileged: true
    be.vm.provider "virtualbox" do |v|
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
