#!/bin/bash
hostname compute-server

#host file
rm -rf /etc/hosts
cp /opt/openstack-working/hosts /etc/hosts

#interface
rm -rf /etc/network/interfaces
cp /opt/openstack-working/interfaces/computeserver/interfaces /etc/network
ifup eth1

