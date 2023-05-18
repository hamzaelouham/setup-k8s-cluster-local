IPADDR=$(ip -4 -o addr show eth1 | awk '{print $4}' | cut -d "/" -f 1 )
NODENAME=master
POD_CIDR='10.244.0.0/16'

sudo kubeadm init --apiserver-advertise-address=$IPADDR  --pod-network-cidr=$POD_CIDR --node-name $NODENAME --cri-socket=unix:///var/run/crio/crio.sock

