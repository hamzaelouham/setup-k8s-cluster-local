echo 'starting script for setup one single node k8s cluster ...!' 

kubernetes_version=1.23.0-00

set -e

echo '==========================================================' 

echo 'Updating system packages ...!'

sudo apt-get update -y 

echo 'installing addition packages ...!'

sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

echo '==========================================================' 

echo 'disable swapping ...!' 

sudo swapoff -a

echo '==========================================================' 

echo 'disable firewall ...!' 

sudo ufw disable

echo '==========================================================' 

echo 'enable net fillter ...! '

sudo modprobe br_netfilter

echo '==========================================================' 

sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF


echo '==========================================================' 
 
echo 'presist config across reboot ...!'

sudo sysctl --system

echo '==========================================================' 

echo 'Installing Runtime ...!'

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg


echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

echo 'starting downloading ...!'

sudo apt-get install -y docker-ce docker-ce-cli containerd.io

echo 'set default setting !'

# sudo mkdir -p /etc/containerd
# containerd config default | sudo tee /etc/containerd/config.toml
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1

sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

echo 'Start & Enable containerd !'

# sudo systemctl enable --now containerd

sudo systemctl restart containerd
sudo systemctl enable containerd

echo '==========================================================' 

echo 'Download the Google Cloud public signing key ...!'

sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo '==========================================================' 

echo 'update old packages one more time...!'

sudo apt-get update -y 

echo 'Installing KUBECTL , KUBELET AND KUBEADM ...! '

sudo apt-get install -y kubelet=${kubernetes_version} kubeadm=${kubernetes_version} kubectl=${kubernetes_version}

echo '==========================================================' 

echo 'starting kubelet deoman ...!'

sudo systemctl start kubelet 

echo 'enable kubelet deoman ...!'

sudo systemctl enable kubelet 

sleep 6

echo '==========================================================' 

echo 'Execute kubeadm init ...!'

echo 'set the control plane ip address ...!'

read MASTER_IP

sudo kubeadm init --apiserver-advertise-address=${MASTER_IP} --pod-network-cidr=10.244.0.0/16 

echo '==========================================================' 

echo 'exit sudo to normal user '

# exit

# sudo -u vagrant -H bash -c 
mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo '==========================================================' 

echo 'Installing Flannel for network ...!'

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

echo '==========================================================' 

echo 'taint nodes (single node cluster )...!'


kubectl taint nodes --all node-role.kubernetes.io/control-plane-

echo 'finishing .../!\'

echo '==========================================================' 
