#!/bin/bash

set -ex

IRONIC_IMAGE=${IRONIC_IMAGE:-"quay.io/metalkube/metalkube-ironic"}
IRONIC_INSPECTOR_IMAGE=${IRONIC_INSPECTOR_IMAGE:-"quay.io/metalkube/metalkube-ironic-inspector"}
IRONIC_DATA_DIR="$PWD/ironic"

sudo podman pull $IRONIC_IMAGE
sudo podman pull $IRONIC_INSPECTOR_IMAGE

mkdir -p "$IRONIC_DATA_DIR/html/images"

# The images directory should contain images and an associated md5sum.
#   - image.qcow2
#   - image.qcow2.md5sum

# set password for mariadb
mariadb_password=$(echo $(date;hostname)|sha256sum |cut -c-20)

# Create pod
sudo podman pod create -n ironic-pod

# Some environment variables for the host system
PROVISION_IP=192.168.30.2
PROVISION_INTERFACE=enp59s0u2.30
PROVISION_RANGE="192.168.30.30,192.168.30.20"

# Start dnsmasq, http, mariadb, and ironic containers using same image
# See this file for env vars you can set, like IP, DHCP_RANGE, INTERFACE
# https://github.com/metalkube/metalkube-ironic/blob/master/rundnsmasq.sh
sudo podman run -d --net host \
                   --privileged \
                   --name dnsmasq \
                   --pod ironic-pod \
		   --env IP=$PROVISION_IP \
                   --env DHCP_RANGE=$PROVISION_RANGE \
                   --env INTERFACE=$PROVISION_INTERFACE \
                   -v $IRONIC_DATA_DIR:/shared \
                   --entrypoint /bin/rundnsmasq ${IRONIC_IMAGE}

# For available env vars, see:
# https://github.com/metalkube/metalkube-ironic/blob/master/runhttpd.sh
sudo podman run -d --net host \
		--privileged \
		--name httpd \
		--pod ironic-pod \
		--env IP=$PROVISION_IP \
     		-v $IRONIC_DATA_DIR:/shared \
		--entrypoint /bin/runhttpd \
		${IRONIC_IMAGE}

# https://github.com/metalkube/metalkube-ironic/blob/master/runmariadb.sh
sudo podman run -d --net host \
		--privileged \
		--name mariadb \
		--pod ironic-pod \
     		-v $IRONIC_DATA_DIR:/shared \
		--entrypoint /bin/runmariadb \
     		--env MARIADB_PASSWORD=$mariadb_password \
		${IRONIC_IMAGE}

# See this file for additional env vars you may want to pass, like IP and INTERFACE
# https://github.com/metalkube/metalkube-ironic/blob/master/runironic.sh
sudo podman run -d --net host \
		--privileged \
		--name ironic \
		--pod ironic-pod \
     		--env MARIADB_PASSWORD=$mariadb_password \
		--env IP=$PROVISION_IP \
		--env INTERFACE=$PROVISION_INTERFACE \
     		-v $IRONIC_DATA_DIR:/shared \
		${IRONIC_IMAGE} 

# Start Ironic Inspector
sudo podman run -d --net host \
		--privileged \
		--name ironic-inspector \
		--pod ironic-pod \
		${IRONIC_INSPECTOR_IMAGE}
