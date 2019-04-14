# delete an existing minikube
minikube delete

# start a new minikube
minikube start

# Run a local ironic installation. All of the variables need to start
# ironic and its associated services are contained in this file.
./run_local_ironic.sh

pushd ~/go/src/github.com/metalkube/baremetal-operator/

# deploy the service account resources, roles, and role bindings
kubectl apply -f deploy/service_account.yaml
kubectl apply -f deploy/role.yaml
kubectl apply -f deploy/role_binding.yaml

# create the baremetal Custom Resource Definition
kubectl apply -f deploy/crds/metalkube_v1alpha1_baremetalhost_crd.yaml

# launch the operator, and throw the process into a background with
# a log file
export OPERATOR_NAME=baremetal-operator
operator-sdk up local --namespace=metalkube > /tmp/metalkube 2>&1 $

kubectl apply -f ./deploy/crds/example-host.yaml

