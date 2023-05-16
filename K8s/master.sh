echo '==========================================================' 

echo 'Starting setup kube-context .../!\'

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




