#!/bin/bash
set -e

MINIKUBEIP=`minikube ip`

echo "Minikube ip is $MINIKUBEIP"

# clean up the routes
sudo route -n delete 172.17.0.0/16
sudo route -n delete 10.0.0.0/24

# Add the routes
sudo route -n add 172.17.0.0/16 $MINIKUBEIP
sudo route -n add 10.0.0.0/24 $MINIKUBEIP

sudo mkdir -p /etc/resolver

cat << EOF | sudo tee /etc/resolver/cluster.local
nameserver 10.0.0.10
domain cluster.local
search_order 1
EOF
