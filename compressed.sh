#!/bin/bash
hostname node01
export scenario=compressed_ha
export vendor=cisco
export vendor_repo=cisco
export vendor_branch=coi-development
cp /opt/openstack-working/cisco.install.sh /opt/puppet_openstack_builder/install-scripts
