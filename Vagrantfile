# Vagrant.configure("2") do |config|
#   config.vm.define "master" do |master|
#     master.vm.box = "bento/ubuntu-18.04"
#     master.vm.hostname = "master"
#     master.vm.network "private_network", ip: "172.16.1.10"

#     master.vm.provider :virtualbox do |vb|
#       vb.customize ["modifyvm", :id, "--memory", 1024]
#       vb.customize ["modifyvm", :id, "--cpus", 2]
#     end
#   end

#   config.vm.define "slave" do |slave|
#     slave.vm.box = "bento/ubuntu-18.04"
#     slave.vm.hostname = "slave"
#     slave.vm.network "private_network", ip: "172.16.1.11"

#     slave.vm.provider :virtualbox do |vb|
#       vb.customize ["modifyvm", :id, "--memory", 1024]
#       vb.customize ["modifyvm", :id, "--cpus", 2]
#     end
#   end
# end
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"
  config.vm.network "private_network", ip: "172.16.1.11"
  
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
end

