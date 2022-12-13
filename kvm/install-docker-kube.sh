#!/bin/bash

# Install Docker
yum install -y yum-utils
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io -y

# Restart Docker
systemctl enable docker
systemctl restart docker

# Issue master init
# https://github.com/containerd/containerd/issues/4581
# rm -rf /etc/containerd/config.toml
# systemctl restart containerd

# Disable SELinux
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

# Disable Firewall
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld

# sysctl
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system >/dev/null 2>&1

# Issue init node
# https://stackoverflow.com/questions/44125020/cant-install-kubernetes-on-vagrant
modprobe br_netfilter

# Disable swap
sed -i '/swap/d' /etc/fstab
swapoff -a

# Add yum repo file for Kubernetes
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install -y -q kubeadm kubelet kubectl

systemctl enable kubelet
systemctl start kubelet

# Configure NetworkManager before attempting to use Calico networking.
cat >>/etc/NetworkManager/conf.d/calico.conf<<EOF
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:tunl*
EOF