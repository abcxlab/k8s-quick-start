#!/bin/bash

sudo service etcd stop
sudo systemctl disable etcd.service
sudo rm /lib/systemd/system/etcd.service
sudo rm /usr/local/bin/etcd
sudo rm /usr/local/bin/etcdctl
sudo rm -rf /opt/etcd/pki
sudo rm -rf /opt/etcd/latest
sudo rm -rf /opt/etcd/data
sudo rm -rf /opt/etcd/etcd-*
