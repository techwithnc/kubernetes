# Setp 5 : Making master node
#sudo kubeadm init --apiserver-advertise-address=192.168.100.71

# Connect to cluster
# kubectl get node
# kubectl get pod
# kubectl get node --kubeconfig /etc/kubernetes/admin.conf

#To start using your cluster, you need to run the following as a regular user:
# mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config

# netstat -tunlp 
# Namespaces
# kubectl get namespace / ns
# kubectl create namespace nc_ns01
# kubectl get pod -n kube-system
 
# Installation weave network addon
#kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# get ip address of all opd in specific namespace
# kubectl describe pod  pod-name -n namespace
# kubectl get pod -n kube-system -o wide

# Generate token for joing to master
# kubeadm token create --print-join-command
# kubectl rollout history deployment nginx-deployment
# kubectl run test-nginx-svc --image=nginx
# kubectl exec -it test-nginx-svc -- bash