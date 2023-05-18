kubernetes_version=1.20.0-00
# echo 'starting script for setup one single node k8s cluster ...!' 
echo 'Setup control plane //!\\'
# 10.0.2.15
set -e

echo '==========================================================' 

echo 'Updating system packages ...!'

sudo apt-get update -y 

echo 'installing addition packages ...!'

sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
clear

echo '==========================================================' 

echo 'disable swapping ...!' 

sudo swapoff -a

echo '==========================================================' 

echo 'disable firewall ...!' 

sudo ufw disable

echo '==========================================================' 

sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF


echo '==========================================================' 
 
echo 'presist config across reboot ...!'
sudo sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.d/99-sysctl.conf
sudo sysctl --system

sleep 6
clear

echo '==========================================================' 

echo 'Installing Container Runtime ...!'

sudo apt-get install -y containerd

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

echo 'Adding netfilter ...!'
sudo modprobe overlay
sudo modprobe br_netfilter

clear
echo 'Starting Containerd ...!'

sudo mkdir -p /etc/containerd

containerd config default | sudo tee /etc/containerd/config.toml

sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd


echo '==========================================================' 

echo 'Download the Google Cloud public signing key ...!'

sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo '==========================================================' 

echo 'update old packages one more time...!'

sudo apt-get update -y 

echo '==========================================================' 

echo 'Installing KUBECTL , KUBELET AND KUBEADM ...! '

sudo apt-get install -y kubelet=${kubernetes_version} kubeadm=${kubernetes_version} kubectl=${kubernetes_version}
clear
# echo '==========================================================' 

# echo 'starting kubelet deoman ...!'

# sudo systemctl start kubelet 

# echo 'enable kubelet deoman ...!'

# sudo systemctl enable kubelet 

# sleep 6
# clear
echo '==========================================================' 

echo 'Execute kubeadm init ...!'

sudo kubeadm reset
# --apiserver-advertise-address=${MASTER_IP} 
sudo kubeadm init  --apiserver-advertise-address=172.16.1.10 --pod-network-cidr=10.244.0.0/16 --cri-socket=unix:///var/run/containerd/containerd.sock
clear
echo '==========================================================' 


# sudo -u vagrant -H bash -c 
mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config
clear
echo '==========================================================' 

echo 'Installing Flannel for network ...!'

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

echo 'finishing .../!\'

echo '==========================================================' 
