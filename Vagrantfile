# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE = "bento/centos-8.1"

Vagrant.configure("2") do |config|

  config.vm.box = BOX_IMAGE

  config.vm.define "frontend" do |fe|
    fe.vm.hostname = "frontend.local"
    fe.vm.network "private_network", ip: "192.168.10.100"

    fe.vm.provision :shell, path: "scripts/bootstrap.sh", privileged: true
    fe.vm.provision :ansible_local do |ansible|
      ansible.config_file       = "ansible/ansible.cfg"
      ansible.playbook          = "ansible/site.yml"
      ansible.inventory_path    = "ansible/inventory"
      ansible.become            = true
      ansible.verbose           = "vv"
      ansible.extra_vars       = {
        ansible_group: "uife",
      }
    end

    fe.vm.provider "virtualbox" do |v|
      v.name = "frontend"
    end
  end

  config.vm.define "backend" do |be|
    be.vm.hostname = "backend.local"
    be.vm.network "private_network", ip: "192.168.10.101"
    be.vm.provision :shell, path: "scripts/bootstrap.sh", privileged: true
    
    be.vm.provision :ansible_local do |ansible|
      ansible.config_file       = "ansible/ansible.cfg"
      ansible.playbook          = "ansible/site.yml"
      ansible.inventory_path    = "ansible/inventory"
      ansible.become            = true
      ansible.verbose           = "vv"
      ansible.extra_vars       = {
        ansible_group: "apibe",
      }
    end

    be.vm.provider "virtualbox" do |v|
      v.name = "bakend"
    end
  end

end
