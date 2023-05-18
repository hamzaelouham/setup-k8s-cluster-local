kubernetes_version=1.20.1-00
OS="xUbuntu_18.04"
# crio version 
VERSION="1.23"

echo 'Setup Strating //!\\'

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
echo 'IPtables to see bridged traffic  /!\'

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system
echo '==========================================================' 
 
echo 'Installing CRI-O Container Runtime !'

cat <<EOF | sudo tee /etc/modules-load.d/crio.conf
overlay
br_netfilter
EOF

# Set up required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

sudo sysctl --system



cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
EOF
cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /
EOF

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -

apt-get update
apt-get install cri-o cri-o-runc cri-tools -y

echo 'Enable and starting CRIO services...'
sudo systemctl daemon-reload
sudo systemctl enable crio --now

echo '==========================================================' 

echo 'Download the Google Cloud public signing key ...!'

mkdir -p /etc/apt/keyrings
curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
# sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
# echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo '==========================================================' 

echo 'update old packages one more time...!'

apt-get update -y 

echo '==========================================================' 

echo 'Installing KUBECTL , KUBELET AND KUBEADM ...! '

apt-get install -y kubelet=${kubernetes_version} kubeadm=${kubernetes_version} kubectl=${kubernetes_version}

apt-mark hold kubelet kubeadm kubectl
clear

echo '==========================================================' 

echo 'finishing .../!\'

echo '==========================================================' 
