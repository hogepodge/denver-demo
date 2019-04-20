#!/bin/bash
set -x

pushd ~/go/src/github.com/metalkube/baremetal-operator/

kubectl create namespace metalkube

# deploy the service account resources, roles, and role bindings
kubectl apply --namespace metalkube -f deploy/service_account.yaml
kubectl apply --namespace metalkube -f deploy/role.yaml
kubectl apply --namespace metalkube -f deploy/role_binding.yaml

# create the baremetal Custom Resource Definition
kubectl apply --namespace metalkube -f deploy/crds/metalkube_v1alpha1_baremetalhost_crd.yaml

# launch the operator, and throw the process into a background with
# a log file
export OPERATOR_NAME=baremetal-operator
operator-sdk up local --namespace metalkube > /tmp/baremetal 2>&1 &
popd

kubectl apply --namespace metalkube -f hosts-down.yaml
