#!/bin/bash
set -x
pushd ~/.

git config --global user.name "Chris Hoge"
git config --global user.email "chris@openstack.org"
git clone git@github.com:hogepodge/denver-demo.git
pushd denver-demo/metalkube
sudo cp ifcfg-enp59s0u2 \
	ifcfg-enp59s0u2.20 \
	ifcfg-enp59s0u2.30 \
	/etc/sysconfig/network-scripts/.
./netup
popd

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin
sudo usermod -a -G libvirt $(whoami)
sudo newgrp libvirt
curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2
sudo install docker-machine-driver-kvm2 /usr/local/bin/
minikube config set vm-driver kvm2

VERSION=1.12.4
OS=linux
ARCH=amd64
GONAME=go${VERSION}.${OS}-${ARCH}.tar.gz
curl https://dl.google.com/go/${GONAME} -o ${GONAME}
sudo tar -C /usr/local -xzf ${GONAME}

echo "Set up your path"

#GOPATH=$HOME/go
#PATH=$PATH:$HOME/.local/bin:$HOME/bin:/usr/local/go/bin:$GOPATH/bin
#METALPATH=$GOPATH/src/github.com/metalkube/baremetal-operator
#
#export OS_URL=http://localhost:6385/
#export OS_TOKEN=ironic
#export PATH
#export GOPATH
#export METALPATH

popd
