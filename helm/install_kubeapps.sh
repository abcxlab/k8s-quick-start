#!/usr/bin/env bash

helm repo add bitnami https://charts.bitnami.com/bitnami
helm update repo 
kubectl create namespace kubeapps
helm install kubeapps --namespace kubeapps bitnami/kubeapps --set useHelm3=true

