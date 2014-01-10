#!/bin/bash
cp -r /opt/puppet_openstack_builder/data/* /etc/puppet/data
cp config.yaml /etc/puppet/data
cp user.compressed_ha.yaml /etc/puppet/data/hiera_data
cp /opt/puppet-openstack-ha/* /usr/share/puppet/modules/openstack-ha
