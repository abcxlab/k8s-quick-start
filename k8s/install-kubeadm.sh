#!/bin/bash
#配置阿里云k8s源
sudo curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo  apt-key add -
sudo bash -c 'cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial main
EOF'

#安装k8s组件
sudo apt-get -y update
sudo apt-get -y install kubelet=1.18.2-00 kubeadm=1.18.2-00 kubectl=1.18.2-00
