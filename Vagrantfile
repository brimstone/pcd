# -*- mode: ruby -*-
# vi: set ft=ruby :

instances = 3
instances = ENV['INSTANCES'].to_i unless ENV['INSTANCES'].nil?
Vagrant.configure(2) do |config|
  config.vm.box = 'pcd'
  config.vm.box_url = 'https://brimstone.github.io/pcd/box.json'
  # config.nfs.functional = true

  config.vm.provider :virtualbox do |v|
    v.gui = true unless ENV['GUI'].nil?
  end

  (1..instances).each do |i|
    config.vm.define "pcd-#{i}" do |box|
      ip = "172.18.8.#{i + 100}"
      box.vm.network :private_network, ip: ip, auto_config: false
      provision = "ifconfig eth1 #{ip} netmask 255.255.255.0 up\n"
      provision += "hostname pcd-#{i}\n"
      provision += "bip 172.16.#{i + 100}.1/24\n"
      box.vm.provision 'shell', run: 'always', inline: provision
    end
  end
end
