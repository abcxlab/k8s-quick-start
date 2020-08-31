#!/bin/bash
## pull kubernetes images from aliyun mirror

#for i in `kubeadm config images list`; do
imglist[0]="k8s.gcr.io/kube-apiserver:v1.18.3"
imglist[1]="k8s.gcr.io/kube-controller-manager:v1.18.3"
imglist[2]="k8s.gcr.io/kube-scheduler:v1.18.3"
imglist[3]="k8s.gcr.io/kube-proxy:v1.18.3"
imglist[4]="k8s.gcr.io/pause:3.1"
imglist[5]="k8s.gcr.io/etcd:3.3.15-0"
imglist[6]="k8s.gcr.io/coredns:1.6.2"
for i in "${imglist[@]}"; do
  imageName=${i#k8s.gcr.io/}
  sudo docker pull registry.aliyuncs.com/google_containers/$imageName
  sudo docker tag registry.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
  sudo docker rmi registry.aliyuncs.com/google_containers/$imageName
done;


## pull flannel images from qiniu mirror
sudo docker pull hub.abcxlab.com/kube/flannel:v0.12.0-amd64
sudo docker tag hub.abcxlab.com/kube/flannel:v0.12.0-amd64 quay.io/coreos/flannel:v0.12.0-amd64

## pull nginx-ingress images from qiniu mirror
sudo docker pull hub.abcxlab.com/kube/nginx-ingress-controller:0.30.0
sudo docker tag hub.abcxlab.com/kube/nginx-ingress-controller:0.30.0 quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.30.0
