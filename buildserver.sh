#!/bin/bash
hostname build-server

#host file
rm -rf /etc/hosts
cp /opt/openstack-working/hosts /etc/hosts

#interface
rm -rf /etc/network/interfaces
cp /opt/openstack-working/interfaces/buildserver/interfaces /etc/network
ifup eth1

