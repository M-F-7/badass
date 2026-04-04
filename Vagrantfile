# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"

  # Disable synced folders completely
  config.vm.synced_folder ".", "/vagrant", disabled: true

  ## Machine 1 : K3s Server
  config.vm.define "badass" do |srv|
    srv.vm.hostname = "badass"
    srv.vm.network "private_network", ip: "192.168.56.110"

    srv.vm.provider :libvirt do |hv|
      hv.cpus = 2
      hv.memory = 1024
      hv.driver = "kvm"
      hv.machine_type = "pc"
      hv.uri = "qemu:///system"
    end
    config.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y git curl vim
    SHELL
  end

  # Forward a port from the guest to the host
  # Uncomment and modify as needed
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network (host-only)
  # Uncomment to enable
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Share an additional folder to the guest VM
  # config.vm.synced_folder "./data", "/vagrant_data"

  # Provision the VM with a shell script
end