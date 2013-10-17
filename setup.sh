#!/bin/bash
echo "running setup"

cd /opt

#pull any repo's I want by default add as needed
rm -rf /opt/grizzly-manifests
git clone http://github.com/CiscoSystems/openstack-installer 
#cp /opt/grizzly-manifests/manifests/* /etc/puppet/manifests
#cp /opt/grizzly-manifests/templates/* /etc/puppet/templates

cp /opt/openstack-working/bin/* /usr/sbin

