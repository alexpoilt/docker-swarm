#!/bin/bash

ssh -o stricthostkeychecking=no root@172.27.11.10 hostname
if [ "$?" -ne 0 ]; then
  echo 'Problemas ao se conectar ao manager em 172.27.11.10'
  exit 1
fi

for X in {1..600}; do
  ssh root@172.27.11.10 which docker > /dev/null
  if [ "$?" -eq 0 ]; then
    break
  fi
  sleep 1
done

if [ "$X" -eq 600 ]; then
  echo 'Timeout esperando o provisionamento do manager'
  exit 1
fi

rsync -r root@172.27.11.10:/var/cache/apt/archives /var/cache/apt

apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common dirmngr curl nfs-common
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
  $(ssh root@172.27.11.10 'docker swarm join-token worker | grep join')
fi

usermod -G docker -a vagrant
