Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"
  config.vm.hostname = "master-node"
  config.vm.network "private_network", ip: "172.16.1.10"

  # config.vm.synced_folder "../data", "/home/vagrant/data"
  # config.vm.provision "file", source: "./copiedfile.txt", destination: "/home/vagrant/copiedfile.txt"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 2048]
    vb.customize ["modifyvm", :id, "--cpus", 2]
  end
end

