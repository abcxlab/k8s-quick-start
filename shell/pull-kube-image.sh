#!/bin/bash
## pull kubernetes images from aliyun mirror
for i in `kubeadm config images list`; do 
  imageName=${i#k8s.gcr.io/}
  sudo docker pull registry.aliyuncs.com/google_containers/$imageName
  sudo docker tag registry.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
  sudo docker rmi registry.aliyuncs.com/google_containers/$imageName
done;

## pull flannel images from qiniu mirror
sudo docker pull quay-mirror.qiniu.com/coreos/flannel:v0.12.0-amd64
sudo docker tag quay-mirror.qiniu.com/coreos/flannel:v0.12.0-amd64 quay.io/coreos/flannel:v0.12.0-amd64

## pull nginx-ingress images from qiniu mirror
sudo docker pull quay-mirror.qiniu.com/kubernetes-ingress-controller/nginx-ingress-controller:0.30.0
sudo docker tag quay-mirror.qiniu.com/kubernetes-ingress-controller/nginx-ingress-controller:0.30.0 quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.30.0
