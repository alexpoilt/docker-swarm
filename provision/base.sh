#!/bin/bash

mkdir -p /root/.ssh
cp /vagrant/files/id_rsa* /root/.ssh
cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys
chown -R root: /root/.ssh/
chmod 400 /root/.ssh/id_rsa*

apt-get update
apt-get install -y rsync
