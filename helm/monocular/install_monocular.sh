#!/usr/bin/env bash

helm repo add stable https://apphub.aliyuncs.com/stable
helm repo add monocular https://helm.github.io/monocular
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

sudo docker tag quay-mirror.qiniu.com/helmpack/chartsvc:v1.10.0  quay.io/helmpack/chartsvc:v1.10.0
sudo docker pull quay-mirror.qiniu.com/helmpack/chartsvc:v1.10.0
helm repo add monocular https://helm.github.io/monocular

sudo docker pull quay-mirror.qiniu.com/helmpack/chart-repo:v1.10.0
sudo docker tag quay-mirror.qiniu.com/helmpack/chart-repo:v1.10.0  quay.io/helmpack/chart-repo:v1.10.0

helm install monocular monocular/monocular -f install_monocular-domains.yaml

