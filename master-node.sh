# kubernetes installation for master node

# Step 1 - installation container runtimes ( containerd )

sudo apt update

# install and configure prerequisites
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Install containerd 
sudo apt update
sudo apt install -y containerd net-tools
sudo systemctl stop containerd

# Configure containerd 
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd

# Step 2 Install kubeadm

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl start kubelet

# way to comfirm - kubeadm version & kubectl version

# Step 3 - need to swap off
sudo swapoff -a

# way to comfirm - cat /proc/swaps & swapon -a

# Setp 4 : Making master node
sudo kubeadm init --apiserver-advertise-address=192.168.70.37

# kubectl get node --kubeconfig /etc/kubernetes/admin.conf

#To start using your cluster, you need to run the following as a regular user:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Installation weave network addon
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

# kubectl describe pod  pod-name -n namespace
kubectl get pod -n kube-system -o wide

