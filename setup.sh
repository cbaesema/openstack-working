#!/bin/bash
echo "running setup"

cd /opt

#pull any repo's I want by default add as needed
rm -rf /opt/puppet_openstack_builder
git clone http://github.com/CiscoSystems/puppet_openstack_builder -b coi-development
rm -rf /opt/puppet-openstack-ha
git clone http://github.com/cbaesema/puppet-openstack-ha -b havana

cp /opt/openstack-working/bin/* /usr/sbin

