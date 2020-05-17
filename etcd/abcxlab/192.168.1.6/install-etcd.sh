#!/bin/bash

BASEDIR=$(dirname "$0")

ETCD_VERSION="v3.4.3"
GITHUB_URL=https://github.com/etcd-io
MIRROR_URL=http://mirror.abcxlab.com
URL=${MIRROR_URL}
ARC="amd64"

sudo mkdir -p /opt/etcd/data
sudo cp -R ${BASEDIR}/pki /opt/etcd/.  
sudo cp ${BASEDIR}/etcd.service /lib/systemd/system/.
sudo cd /opt/etcd

sudo wget ${URL}/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-${ARC}.tar.gz 
sudo tar -xvf etcd-${ETCD_VERSION}-linux-${ARC}.tar.gz 
sudo rm etcd-${ETCD_VERSION}-linux-${ARC}.tar.gz
sudo ln -s etcd-${ETCD_VERSION}-linux-${ARC} latest 

sudo groupadd --system etcd
sudo useradd -s /sbin/nologin --system -g etcd etcd
sudo ln -s /opt/etcd/latest/etcd /usr/local/bin/etcd
sudo ln -s /opt/etcd/latest/etcdctl /usr/local/bin/etcdctl
sudo chown -R etcd:etcd /opt/etcd

sudo systemctl enable etcd.service
sudo service etcd start 
