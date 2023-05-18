# ip=$(ip -4 -o addr show eth0 | awk '{print $4}' | cut -d "/" -f 1 )
# # echo $ip

# kubernetes_version=1.23.0-00

# sudo apt-get install -y kubelet=${kubernetes_version} kubeadm=${kubernetes_version}


sudo apt-get update -qq >/dev/null 2>&1
sudo apt-get install -qq -y ca-certificates curl gnupg lsb-release >/dev/null 2>&1
 mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg >/dev/null 2>&1
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -qq >/dev/null 2>&1
sudo apt-get install -qq -y containerd.io >/dev/null 2>&1
containerd config default > /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd >/dev/null 2>&1


# sudo install -m 0755 -d /etc/apt/keyrings
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# sudo chmod a+r /etc/apt/keyrings/docker.gpg


# echo \
#   "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#   "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
#   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# sudo apt-get update

# echo 'starting downloading ...!'

# sudo apt-get install -y containerd.io

# echo 'set default setting !'

# # sudo mkdir -p /etc/containerd
# # containerd config default | sudo tee /etc/containerd/config.toml
# containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1

# sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

# echo 'Start & Enable containerd !'

# # sudo systemctl enable --now containerd