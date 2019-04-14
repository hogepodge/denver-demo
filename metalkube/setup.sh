#!/bin/bash
set -x

#git config --global user.name "Chri Hoge"
#git config --global user.email "chris@openstack.org"
#git clone git@github.com:hogepodge/denver-demo.git
#pushd denver-demo/metalkube
#sudo cp ifcfg-enp59s0u2 \
#	ifcfg-enp59s0u2.20 \
#	ifcfg-enp59s0u2.30 \
#	/etc/sysconfig/network-scripts/.
#./netup
#popd

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin
sudo usermod -a -G libvirt $(whoami)
sudo newgrp libvirt
curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2
sudo install docker-machine-driver-kvm2 /usr/local/bin/
minikube config set vm-driver kvm2
