# -*- mode: ruby -*-
# vi: set ft=ruby :

manifest = ENV['MANIFEST'] || 'default.pp'

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network :private_network, ip: "192.168.111.10"
end
