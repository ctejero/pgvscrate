# -*- mode: ruby -*-
# vi: set ft=ruby :

# amount of RAM for Vagrant box
BOX_RAM_MB = "5120"

# number of CPUs for Vagrant box
BOX_CPU_COUNT = "3"

# tpc-h load
TPCH_LOAD = "-s1"

# 
Vagrant.configure("2") do |config|
  
  # 
  config.vm.box = "centos/7"

  #
  config.vm.provider "virtualbox" do | vb |
  
    # Customize the amount of memory on the VM:
    vb.memory = BOX_RAM_MB
  
    # Customize the cpus for the VM:
    vb.cpus = BOX_CPU_COUNT
  end

  #
  config.vm.provider "libvirt" do | lb |
  
    # Customize the amount of memory on the VM:
    lb.memory = BOX_RAM_MB
  
    # Customize the cpus for the VM:
    lb.cpus = BOX_CPU_COUNT
  end

  #
  config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__auto: true

  # 
  config.vm.provision "shell", path: "provisioning.sh", args: [TPCH_LOAD]
end

