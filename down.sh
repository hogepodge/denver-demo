#!/bin/bash 
set -x

killall operator-sdk
minikube delete
./stop_local_ironic.sh
