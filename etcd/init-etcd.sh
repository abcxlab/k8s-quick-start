#!/bin/bash

#替换成自己的ETCD群集节点，格式为： ([HOST_NAME] = [HOST_IP] ...)
declare -A ETCDHOST_MAP=(["xant"]="192.168.1.4" ["xbee"]="192.168.1.6" ["xcat"]="192.168.1.8")

function gen_conf(){
NAME=$1
HOST=$2
CLUSTER=$3
mkdir -p "${BASEDIR}/etcd/${HOST}"
cat << EOF > ${BASEDIR}/etcd/${HOST}/kubeadmcfg.yaml
apiVersion: "kubeadm.k8s.io/v1beta2"
kind: ClusterConfiguration
etcd:
    local:
        serverCertSANs:
        - "${HOST}"
        peerCertSANs:
        - "${HOST}"
        extraArgs:
            initial-cluster: ${CLUSTER} 
            initial-cluster-state: new
            name: ${NAME}
            listen-peer-urls: https://${HOST}:2380
            listen-client-urls: https://${HOST}:2379
            advertise-client-urls: https://${HOST}:2379
            initial-advertise-peer-urls: https://${HOST}:2380
EOF
}

function gen_cert(){
	ETCD_HOST=$1
	mkdir -p "${BASEDIR}/etcd/${ETCD_HOST}/pki"
	sudo kubeadm init phase certs etcd-server --config=${BASEDIR}/etcd/${ETCD_HOST}/kubeadmcfg.yaml
	sudo kubeadm init phase certs etcd-peer --config=${BASEDIR}/etcd/${ETCD_HOST}/kubeadmcfg.yaml
	sudo kubeadm init phase certs etcd-healthcheck-client --config=${BASEDIR}/etcd/${ETCD_HOST}/kubeadmcfg.yaml
	sudo kubeadm init phase certs apiserver-etcd-client --config=${BASEDIR}/etcd/${ETCD_HOST}/kubeadmcfg.yaml
	sudo cp -R /etc/kubernetes/pki/etcd/*  ${BASEDIR}/etcd/${ETCD_HOST}/pki/.
	sudo cp -R /etc/kubernetes/pki/apiserver-etcd*  ${BASEDIR}/etcd/${ETCD_HOST}/pki/.
}	

function gen_service(){
	NAME=$1
 	HOST=$2
	CLUSTER=$3
	mkdir -p "${BASEDIR}/etcd/${HOST}"
cat << EOF > ${BASEDIR}/etcd/${HOST}/etcd.service
[Unit]
Description=etcd key-value store
Documentation=https://github.com/etcd-io/etcd
After=network.target

[Service]
User=etcd
Type=notify
ExecStart=/usr/local/bin/etcd --name=${NAME} --data-dir=/opt/etcd/data --initial-cluster-token=etcd-cluster --snapshot-count=10000 --initial-advertise-peer-urls=https://${HOST}:2380 --initial-cluster=${CLUSTER} --advertise-client-urls=https://${HOST}:2379 --listen-client-urls=https://127.0.0.1:2379,https://${HOST}:2379 --listen-peer-urls=https://${HOST}:2380 --listen-metrics-urls=http://127.0.0.1:2381 --client-cert-auth=true --trusted-ca-file=/opt/etcd/pki/ca.crt --key-file=/opt/etcd/pki/server.key --cert-file=/opt/etcd/pki/server.crt --peer-client-cert-auth=true --peer-trusted-ca-file=/opt/etcd/pki/ca.crt --peer-key-file=/opt/etcd/pki/peer.key --peer-cert-file=/opt/etcd/pki/peer.crt --logger=zap
Restart=always
RestartSec=10s
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target
EOF
}

#main


BASEDIR=$(dirname "$0")

# 初始化etcd根证书
sudo kubeadm init phase certs etcd-ca

#CLUSTER="xant=https://192.168.1.4:2380,xbee=https://192.168.1.6:2380,xcat=https://192.168.1.8:2380"
CLUSTER=""
HEAD=0
for key in "${!ETCDHOST_MAP[@]}"; do
	if [ "$HEAD" -eq "0" ] 
	then 
	  	CLUSTER="${key}=https://${ETCDHOST_MAP[$key]}:2380"
	else
		CLUSTER="${CLUSTER},${key}=https://${ETCDHOST_MAP[$key]}:2380"
	fi
	HEAD=1
done
for key in "${!ETCDHOST_MAP[@]}"; do
	gen_conf $key  ${ETCDHOST_MAP[$key]} ${CLUSTER}
	gen_cert ${ETCDHOST_MAP[$key]}
	gen_service $key  ${ETCDHOST_MAP[$key]} ${CLUSTER}
	mkdir -p "${BASEDIR}/etcd/${HOST}"
	cp ${BASEDIR}/install-etcd.sh  ${BASEDIR}/etcd/${HOST}/.
	cp ${BASEDIR}/uninstall-etcd.sh  ${BASEDIR}/etcd/${HOST}/.
done

sudo chown -R ${USER} ${BASEDIR}/etcd

# 初始化清理
sudo rm -rf /etc/kubernetes/pki/etcd
sudo rm -rf /etc/kubernetes/pki/apiserver-etcd*
