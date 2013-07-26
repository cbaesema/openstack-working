#!/bin/bash
echo "running setup"

cd /opt

#pull any repo's I want by default add as needed
rm -rf /opt/grizzly-manifests
git clone http://github.com/CiscoSystems/grizzly-manifests -b multi-node
cp /opt/grizzly-manifests/manifests/* /etc/puppet/manifests
cp /opt/grizzly-manifests/templates/* /etc/puppet/templates

cp /opt/openstack-working/buildserver /usr/sbin
cp /opt/openstack-working/controlserver /usr/sbin
cp /opt/openstack-working/computeserver1 /usr/sbin
cp /opt/openstack-working/swiftproxy /usr/sbin

#copy the site.pp in place
cp /opt/openstack-working/site/site.pp /etc/puppet/manifests
rm -rf /etc/apt/sources.list
cp /opt/openstack-working/sources.list /etc/apt
apt-get update
