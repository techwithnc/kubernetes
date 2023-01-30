# Create Key for user nyeinchan
openssl genrsa -out admin-nyeinchan.key 2048

# Create CertificateSigningRequest for Key
openssl req -new -key admin-nyeinchan.key -subj "/CN=nyeinchan" -out admin-nyeinchan.csr
# "/CN=nyeinchan" is main.it is used by kubernetes as user name.


# Create CSRs K8s Resources
# send it .csr file to kubernetes for signing 
# ny
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: admin-nyeinchan
spec:
  request: #base64 coded key of csr file#
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 8640000  # 100 days
  usages:
  - client auth

  
# Create base64 coded key for .csr file
cat admin-nyeinchan.csr | base64 | tr -d "\n"  

# Apply csr file
kubectl apply -f admin-nyeinchan-csr.yaml

# list csr file
kubectl get scr
# Need to approved for pending csr .

# Approve SCR 
kubectl certificate approve csr-name.

# Need to print out approved csr file to yaml format for coping certifcate (base64 encoded file)
kubectl get csr admin-nyeinchan -o yaml 

# decoded certificate key to actual certificate as file 
echo 'paste here encoded certificates key' | base64 --decode > nyeinchan.crt

# Create kubenetes config file for user nyeinchan
# Copy config file from kubernetes master node and edit it
