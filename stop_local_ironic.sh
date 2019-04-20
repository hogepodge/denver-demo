#!/bin/bash

set -ex

for name in ironic ironic-inspector dnsmasq httpd mariadb; do
    sudo podman ps | grep -w "$name$" && sudo podman stop $name
    sudo podman ps --all | grep -w "$name$" && sudo podman rm $name 
done

# Remove existing pod
if  sudo podman pod exists ironic-pod ; then
    sudo podman pod rm ironic-pod 
fi
