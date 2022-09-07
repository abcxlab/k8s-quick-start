#!/bin/bash
#安装系统库依赖
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common

#配置阿里云Docker源
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"

#安装Docker
sudo apt-get -y update
sudo apt-get -y install docker-ce=5:19.03.15~3-0~ubuntu-focal


#当前用户添加docker权限
sudo usermod -aG docker ${USER}


#修改docker配置
sudo bash -c 'cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ],
  "registry-mirrors": [
    "https://hub-mirror.c.163.com"
  ]
}
EOF'


#重启docker
sudo service docker restart
