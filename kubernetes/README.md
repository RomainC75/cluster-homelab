# names/archi

# kubeadm - basics - all
# Download the public signing key for the Kubernetes package repositories
# $ curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# add the repo :
# $ echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list


# containerd - all
# $ sudo apt update 
# $ sudo apt install -y containerd kubelet kubeadm kubectl


# cgroups (systemd or cgoupfs)
# verify the init system. -> choose the cgroups based on the response
# $ ps -p1
# Starting with v1.22 and later, when creating a cluster with kubeadm, if the user does not set the cgroupDriver field under KubeletConfiguration, kubeadm defaults it to systemd.
# -> so we do nothing

# configuring the systemd cgroup driver
# create file /etc/containerd/config.toml
# $ mkdir -p /etc/containerd
# and set : 
# [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
#   ...
#   [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
#     SystemdCgroup = true
# => get the default config, activate SystemCgroup, and copy the entire configuration to the file with this command : 
# $ containerd config default | sed 's/SystemdCgroup = false/SystemdCgroup = true/' | sudo tee /etc/containerd/config.toml
# restart containerd:
# $ sudo systemctl restart containerd


# ! ON EVERY MASTER/NODES
# before initializing kubeadm : 
# disable swap : 
# $ sudo swapoff -a
# and comment swap.img in the file : 
# $ sudo vim /etc/fstab


# ! ON EVERY MASTER/NODES
# activate ip_forward :
# uncomment "net.ipv4.ip_forward=1 in /etc/sysctl.conf
# then restart sysctl :
# $ sudo sysctl -p
# (with ansible : ansible all -b -m sysctl -a "name=net.ipv4.ip_forward value=1 state=present reload=yes")

# MASTER : initialize control-plane node
# $ sudo kubeadm init --apiserver-advertise-address 192.168.56.254 --pod-network-cidr "10.244.0.0/16" --upload-certs
# ! get the "kubeadm join ..." command for the worker nodes  

# MASTER : copy /etc/kubernetes/admin.conf to ~/.kube:
  # $ mkdir -p $HOME/.kube
  # $ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  # $ sudo chown $(id -u):$(id -g) $HOME/.kube/config

# ? verify with : kubectl get nodes 

# ! ON EVVERY MASTER/NODES
# set the br_netfilter for the flannel pod : 
# $ sudo modprobe br_netfilter
# Persist the setting (in case of reboot)
# $ echo 'br_netfilter' | sudo tee /etc/modules-load.d/k8s.conf
# Set required sysctl params :
# $ cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
# net.bridge.bridge-nf-call-iptables  = 1
# net.ipv4.ip_forward                 = 1
# net.bridge.bridge-nf-call-ip6tables = 1
# EOF
# Apply them : 
# $ sudo sysctl --system


# deploy the flannel network plugin in the master node : 
# $ kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# let the worker nodes join the cluster
# ! $ kubeadm join 192.168.56.254:6443 --token uvrvqe.0fgcpnyxs0bpjxjt \
        # --discovery-token-ca-cert-hash sha256:d3616312d5919604d3bd532e6df8784e49f4b59006b55eefe26570871fe3d9bc

# ? test nodes  with : 
# kubectl get nodes
