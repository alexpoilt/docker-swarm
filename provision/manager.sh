#!/bin/bash

apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common dirmngr vim curl nfs-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

echo '{
	"exec-opts": ["native.cgroupdriver=systemd"],
	"log-driver": "journald"
}' > /etc/docker/daemon.json

sleep 1

systemctl restart docker

docker system info | grep 'Swarm: active' > /dev/null
if [ "$?" -ne 0 ]; then
  docker swarm init --advertise-addr=172.27.11.10
fi

usermod -G docker -a vagrant
