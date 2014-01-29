#!/bin/bash
hostname all-in-one
export scenario=all_in_one
export vendor=cisco
export vendor_repo=cisco
export vendor_branch=coi-development
cp /opt/openstack-working/cisco.install.sh /opt/puppet_openstack_builder/install-scripts

rm /opt/puppet_openstack_builder/data/hiera_data/vendor/cisco_coi_common.yaml

