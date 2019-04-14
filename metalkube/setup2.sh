#!/bin/bash
set -x 
pushd ~/.

mkdir -p go/bin
curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

mkdir -p $GOPATH/src/github.com/operator-framework
pushd $GOPATH/src/github.com/operator-framework
git clone https://github.com/operator-framework/operator-sdk
pushd operator-sdk
git checkout master
make dep
make install
popd
popd

eval $(go env)
mkdir -p $GOPATH/src/github.com/metalkube
cd $GOPATH/src/github.com/metalkube
git clone https://github.com/metalkube/baremetal-operator.git

popd
