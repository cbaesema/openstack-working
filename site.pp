# This document serves as an example of how to deploy
# basic multi-node openstack environments.
# In this scenario Quantum is using OVS with GRE Tunnels

########### Proxy Configuration ##########
# If you use an HTTP/HTTPS proxy, uncomment this setting and specify the
# correct proxy URL.  If you do not use an HTTP/HTTPS proxy, leave this
# setting commented out.
#$proxy = "http://proxy-server:port-number"

########### package repo configuration ##########
#
# The package repos used to install openstack
$package_repo = 'cisco_repo'
# Alternatively, the upstream Ubuntu package from cloud archive can be used
# $package_repo = 'cloud_archive'

# If you are behind a proxy you may choose not to use our ftp distribution, and
# instead try our http distribution location. Note the http location is not
# a permanent location and may change at any time.
#$location = 'ftp://ftpeng.cisco.com/openstack/cisco'
# Alternate, uncomment this one, and comment out the one above.
$location = "http://openstack-repo.cisco.com/openstack"

########### Build Node (Cobbler, Puppet Master, NTP) ######
# Change the following to the host name you have given your build node.
# This name should be in all lower case letters due to a Puppet limitation
# (refer to http://projects.puppetlabs.com/issues/1168).
$build_node_name        = 'localhost'

########### NTP Configuration ############
# Change this to the location of a time server in your organization accessible
# to the build server.  The build server will synchronize with this time
# server, and will in turn function as the time server for your OpenStack
# nodes.
$ntp_servers = ['time.ntp.org']

########### Build Node Cobbler Variables ############
# Change these 5 parameters to define the IP address and other network
# settings of your build node.  The cobbler node *must* have this IP
# configured and it *must* be on the same network as the hosts to install.
$cobbler_node_ip        = '192.168.1.2'
$node_subnet            = '192.168.1.0'
$node_netmask           = '255.255.255.0'
# This gateway is optional - if there's a gateway providing a default route,
# specify it here.  If not, comment this line out.
#$node_gateway           = '192.168.242.1'
# This domain name will be the name your build and compute nodes use for the
# local DNS.  It doesn't have to be the name of your corporate DNS - a local
# DNS server on the build node will serve addresses in this domain - but if
# it is, you can also add entries for the nodes in your corporate DNS
# environment they will be usable *if* the above addresses are routeable
# from elsewhere in your network.
$domain_name            = 'eau.wi.charter.com'
# This setting likely does not need to be changed.
# To speed installation of your OpenStack nodes, it configures your build
# node to function as a caching proxy storing the Ubuntu install files used
# to deploy the OpenStack nodes.
$cobbler_proxy          = "http://${cobbler_node_ip}:3142/"

####### Preseed File Configuration #######
# This will build a preseed file called 'cisco-preseed' in
# /etc/cobbler/preseeds/
# The preseed file automates the installation of Ubuntu onto the OpenStack
# nodes.
#
# The following variables may be changed by the system admin:
# 1) admin_user
# 2) password_crypted
# 3) autostart_puppet -- whether the puppet agent will auto start
# Default user is: localadmin
# Default SHA-512 hashed password is "ubuntu":
# To generate a new SHA-512 hashed password, run the following replacing
# the word "password" with your new password. Then use the result as the
# $password_crypted variable.
# python -c "import crypt, getpass, pwd; print crypt.crypt('password', '\$6\$UfgWxrIv\$')"
$admin_user             = 'localadmin'
$password_crypted       = '$6$UfgWxrIv$k4KfzAEMqMg.fppmSOTd0usI4j6gfjs0962.JXsoJRWa5wMz8yQk4SfInn4.WZ3L/MCt5u.62tHDGB36EhiKF1'
$autostart_puppet       = false

# If the setup uses the UCS B-series blades, enter the port on which the
# ucsm accepts requests. By default the UCSM is enabled to accept requests
# on port 443 (https). If https is disabled and only http is used, set
# $ucsm_port = '80'
$ucsm_port = '443'

########### OpenStack Variables ############
# These values define parameters which will be used to deploy and configure
# OpenStack once Ubuntu is installed on your nodes.
#
# Change these next 3 parameters to the network settings of the node which
# will be your OpenStack control node.  Note that the $controller_hostname
# should be in all lowercase letters due to a limitation of Puppet
# (refer to http://projects.puppetlabs.com/issues/1168).
$controller_node_address       = '192.168.1.3'
$controller_node_network       = '192.168.1.0'
$controller_hostname           = 'control-server'
# Specify the network which should have access to the MySQL database on
# the OpenStack control node. Typically, this will be the same network as
# defined in the controller_node_network parameter above. Use MySQL network
# wild card syntax to specify the desired network.
$db_allowed_network            = '192.168.1.%'
# These next two values typically do not need to be changed. They define the
# network connectivity of the OpenStack controller.  This is the interface
# used to connect to Horizon dashboard.
$controller_node_public        = $controller_node_address
# This is the interface used for external backend communication.
$controller_node_internal      = $controller_node_address

# Specify the address of the Swift proxy
# If you have multiple Swift proxy nodes, this should be the address
# of the VIP used to load-balance across the individual nodes.
# Uncommenting this variable will enable the keystone swift endpoint.
$swift_proxy_address           = '192.168.1.5'

# These next two parameters specify the networking hardware used in each node
# Current assumption is that all nodes have the same network interfaces and are
# cabled identically.  However, with the control node acting as network node,
# only the control node requires 2 interfaces.  For all other nodes, a single
# interface is functional with the assumption that:
#   a) The public_interface will have an IP address reachable by
#      all other nodes in the openstack cluster.  This address will
#      be used for API Access, for the Horizon UI, and as an endpoint
#      for the default GRE tunnel mechanism used in the OVS network
#      configuration.
#   b) The external_interface is used to provide a Layer2 path for
#      the l3_agent external router interface.  It is expected that
#      this interface be attached to an upstream device that provides
#      a L3 router interface, with the default router configuration
#      assuming that the first non "network" address in the external
#      network IP subnet will be used as the default forwarding path
#      if no more specific host routes are added.
#
# It is assumed that this interface has an IP Address associated with it
# and is available and connected on every host in the OpenStack cluster
$public_interface               = 'eth1'
# The external_interface is used for external connectivity in association
# with the l3_agent external router interface, providing floating IPs
# (this is only required on the network/controller node)
$external_interface             = 'eth2'

# Uncomment and customize these next three variables to use a provider
# network model
# $ovs_vlan_ranges is used to name a physical network and indicate the
# VLAN tag or # tags that should be associated with that network. The first
# parameter is the network name, while the second parameter is the starting
# tag # number and the third parameter is the ending tag number
#$ovs_vlan_ranges = 'physnet1:1000:2000'
# $ovs_bridge_uplinks is used to map an OVS bridge to a physical network
# interface. The first parameter is the OVS external bridge name, and the
# second parameter is the physical network interface which should be
# associated with it
#$ovs_bridge_uplinks = ['br-ex:eth0']
# $ovs_bridge_mappings is used to map an OVS bridge to a physical network.
# The first parameter is the physical network name and the second parameter
# is the OVS external bridge name
#$ovs_bridge_mappings = ['physnet1:br-ex']

# Select the drive on which Ubuntu and OpenStack will be installed in each
# node. The current assumption is that all nodes will be installed on the
# same device name.
$install_drive                  = '/dev/sda'

########### OpenStack Service Credentials ############
# This block of parameters is used to change the user names and passwords
# used by the services which make up OpenStack. The following defaults should
# be changed for any production deployment.
$admin_email             = 'root@localhost'
$admin_password          = 'Cisco123'
$keystone_db_password    = 'keystone_db_pass'
$keystone_admin_token    = 'keystone_admin_token'
$mysql_root_password     = 'mysql_db_pass'
$nova_user               = 'nova'
$nova_db_password        = 'nova_pass'
$nova_user_password      = 'nova_pass'
$libvirt_type            = 'kvm'
$glance_db_password      = 'glance_pass'
$glance_user_password    = 'glance_pass'
$glance_sql_connection   = "mysql://glance:${glance_db_password}@${controller_node_address}/glance"
$cinder_user             = 'cinder'
$cinder_user_password    = 'cinder_pass'
$cinder_db_password      = 'cinder_pass'
$quantum_user_password   = 'quantum_pass'
$quantum_db_password     = 'quantum_pass'
$rabbit_password         = 'openstack_rabbit_password'
$rabbit_user             = 'openstack_rabbit_user'
$swift_password          = 'swift_pass'
$swift_hash              = 'swift_secret'
# Nova DB connection
$sql_connection          = "mysql://${nova_user}:${nova_db_password}@${controller_node_address}/nova"
# Glance backend configuration, supports 'file', 'swift', or 'rbd'.
$glance_backend      = 'file'

# Set this option to true to use RBD-backed glance. This will store
# your glance images in your ceph cluster.
#$glance_ceph_enabled = true
#$glance_ceph_user    = 'admin'
#$glance_ceph_pool    = 'images'

# If you are using a controller node as a ceph MON node then you
#   need to also set this to true to enable glance on ceph.
#   Also ensure that the controller node stanze contains the mon
#   class declarations.
$controller_has_mon = true

# If you are using compute hosts as ceph OSD servers then you
#   need to set this to true
$osd_on_compute = true

###### Quantum plugins #######
# Use either OVS (the default) or Cisco quantum plugin:
# $quantum_core_plugin = 'ovs'
# $quantum_core_plugin = 'cisco'
# if neither is specified, OVS will be used

# If using the Cisco plugin, use either OVS or n1k for virtualised l2
# $cisco_vswitch_plugin = 'ovs'
# $cisco_vswitch_plugin = 'n1k'
# If neither is specified, OVS will be used

# If using the Cisco plugin, Nexus hardware can be used for l2
# $cisco_nexus_plugin = 'nexus'
# By default this will not be used

# If using the nexus sub plugin, specify the hardware layout by
# using the following syntax:
# $nexus_config = { 'SWITCH_IP' => { 'COMPUTE_NODE_NAME' : 'PORT' } }
#
# SWITCH_IP is the ip address of a nexus device
# COMPUTE_NODE_NAME is the hostname of an openstack compute node
# PORT is the port in the switch that compute node is plugged into

# A more complete example with multiple switches and nodes:
# 
# $nexus_config = {'1.1.1.1' =>   {'compute1' => '1/1',
#                                  'compute2' => '1/2' },
#                  '2.2.2.2' =>   {'compute3' => '1/3',
#                                  'compute4' => '1/4'}
#                 }
#

# Set the nexus login credentials by creating a list
# of switch_ip/username/password strings as per the example below:
#
# $nexus_credentials = ['1.1.1.1/nexus_username1/secret1',
#                       '2.2.2.2/nexus_username2/secret2']
#
# At this time the / character cannot be used as a nexus
# password.

# The nexus plugin also requires the ovs plugin to be set to
# vlan mode, which can be done by uncommenting the following line:
# $tenant_network_type = 'vlan'

########### Test variables ############
# Variables used to populate test script:
# /tmp/test_nova.sh
#
# Image to use for tests. Accepts 'kvm' or 'cirros'.
$test_file_image_type = 'kvm'

#### end shared variables #################

# Storage Configuration
# Set to true to enable Cinder services.
$cinder_controller_enabled     = true

# Set to true to enable Cinder deployment to all compute nodes.
$cinder_compute_enabled        = true

# The cinder storage driver to use Options are iscsi or rbd(ceph). Default
# is 'iscsi'.
$cinder_storage_driver         = 'iscsi'

# The cinder_ceph_enabled configures cinder to use rbd-backed volumes.
# $cinder_ceph_enabled           = true


####### OpenStack Node Definitions #####
# This section is used to define the hardware parameters of the nodes
# which will be used for OpenStack. Cobbler will automate the installation
# of Ubuntu onto these nodes using these settings.

# The build node name is changed in the "node type" section further down
# in the file. This line should not be changed here.
node 'build-node' inherits master-node {

# This block defines the control server. Replace "control-server" with the
# host name of your OpenStack controller, and change the "mac" to the MAC
# address of the boot interface of your OpenStack controller. Change the
# "ip" to the IP address of your OpenStack controller.  The power_address
# parameter specifies the address to use for device power management,
# power_user and power_password specify the login credentials to use for
# power management, and power_type determines which Cobbler fence script
# is used for power management.  Supported values for power_type are
# 'ipmitool' for generic IPMI devices and UCS C-series servers in standalone
# mode or 'ucs' for C-series or B-series UCS devices managed by UCSM.

  cobbler_node { 'control-server':
    mac            => '00:11:22:33:44:55',
    ip             => '192.168.1.3',
    power_address  => '192.168.1.3',
    power_user     => 'admin',
    power_password => 'password',
    power_type     => 'ipmitool',
  }

# This block defines the first compute server. Replace "compute-server01"
# with the host name of your first OpenStack compute node (note: the hostname
# should be in all lowercase letters due to a limitation of Puppet; refer to
# http://projects.puppetlabs.com/issues/1168), and change the "mac" to the
# MAC address of the boot interface of your first OpenStack compute node.
# Change the "ip" to the IP address of your first OpenStack compute node.

# Begin compute node
  cobbler_node { 'compute-server01':
    mac            => '11:22:33:44:55:66',
    ip             => '192.168.1.4',
    power_address  => '192.168.1.4',
    power_user     => 'admin',
    power_password => 'password',
    power_type     => 'ipmitool',
  }

# Example with UCS blade power_address with a sub-group (in UCSM), and
# a ServiceProfile for power_id.
#  cobbler_node { "compute-server01":
#    node_type => "compute",
#    mac => "11:22:33:44:66:77",
#    ip => "192.168.242.21",
#    power_address  => "192.168.242.121:org-cisco",
#    power_id => "OpenStack-1",
#    power_type => 'ucs',
#    power_user => 'admin',
#    power_password => 'password'
#  }
# End compute node

# Standalone cinder storage nodes. If cinder is enabled above,
# it is automatically installed on all compute nodes. The below definition
# allows the addition of cinder volume only nodes.
# cobbler_node { "cinder-storage1":
# node_type => "cinder-storage",
# mac => "11:22:33:44:55:66",
# ip => "192.168.242.22",
# power_address => "192.168.242.122",
# power_user => "admin",
# power_password => "password"
# power_type => "ipmitool"
# }


### Repeat as needed ###
# Make a copy of your compute node block above for each additional OpenStack
# node in your cluster and paste the copy in this section. Be sure to change
# the host name, mac, ip, and power settings for each node.

# This block defines the first swift proxy server. Replace "swift-server01"
# with the host name of your first OpenStack swift proxy node (note:
# the hostname should be in all lowercase letters due to a limitation of
# Puppet; refer to http://projects.puppetlabs.com/issues/1168), and change
# the "mac" to the MAC address of the boot interface of your first OpenStack
# swift proxy node.  Change the "ip" to the IP address of your first
# OpenStack swift proxy node.

# Begin swift proxy node
  cobbler_node { "swift-proxy":
    mac            => "A4:4C:11:13:3D:07",
    ip             => "192.168.1.5",
    power_address  => "192.168.1.5"
  }

# This block defines the first swift storage server. Replace "swift-storage01"
# with the host name of your first OpenStack swift storage node (note: the
# hostname should be in all lowercase letters due to a limitation of Puppet;
# refer to http://projects.puppetlabs.com/issues/1168), and change the "mac"
# to the MAC address of the boot interface of your first OpenStack swift
# storage node.  Change the "ip" to the IP address of your first OpenStack
# swift storage node.

# Begin swift storage node
  cobbler_node { "swift-storage01":
    mac            => "A4:4C:11:13:BA:17",
    ip             => "192.168.1.6",
    power_address  => "192.168.1.6",
  }

  cobbler_node { "swift-storage02":
    mac            => "A4:4C:11:13:BC:56",
    ip             => "192.168.1.7",
    power_address  => "192.168.1.7",
  }

  cobbler_node { "swift-storage03":
    mac            => "A4:4C:11:13:B9:8D",
    ip             => "192.168.1.8",
    power_address  => "192.168.1.8"
  }

### Repeat as needed ###
# Make a copy of your swift storage node block above for each additional
# node in your swift cluster and paste the copy in this section. Be sure
# to change the host name, mac, ip, and power settings for each node.

### this block defines the ceph monitor nodes
### you will need to add a node type for each additional mon node
### eg ceph-mon02, etc. This is due to their unique id requirements
  cobbler_node { "ceph-mon01":
    mac           => "11:22:33:cc:bb:aa",
    ip            => "192.168.1.9",
    power_address => "192.168.1.9",
  }

### this block define ceph osd nodes
### add a new entry for each node
  cobbler_node { "ceph-osd01":
    mac           => "11:22:33:cc:bb:aa",
    ip            => "192.168.1.10",
    power_address => "192.168.1.10",
  }

  cobbler_node { "ceph-osd02":
    mac           => "11:22:33:cc:bb:aa",
    ip            => "192.168.1.11",
    power_address => "192.168.1.11",
  }

  cobbler_node { "ceph-osd03":
    mac           => "11:22:33:cc:bb:aa",
    ip            => "192.168.1.12",
    power_address => "192.168.1.12",
  }



### End repeated nodes ###
}

### Node types ###
# These lines specify the host names in your OpenStack cluster and what the
# function of each host is.  internal_ip should be the same as what is
# specified as "ip" in the OpenStack node definitions above.
# This sets the IP for the private(internal) interface of controller nodes
# (which is predefined already in $controller_node_internal, and the internal
# interface for compute nodes.
# In this example, eth0 is both the public and private interface for the
# controller.
# tunnel_ip allows you to create a network specifically for GRE tunneled
# traffic between compute and network nodes. Generally, you will want to
# use "ip" from the OpenStack node definitions above.
# This sets the IP for the private interface of compute and network nodes.

# Change build_server to the host name of your build node.
# Note that the hostname should be in all lowercase letters due to a
# limitation of Puppet (refer to http://projects.puppetlabs.com/issues/1168).
node build-server inherits build-node { }

# Change control-server to the host name of your control node.  Note that the
# hostname should be in all lowercase letters due to a limitation of Puppet
# (refer to http://projects.puppetlabs.com/issues/1168).
node 'control-server' inherits os_base {
  class { 'allinone':}
  class {'coe::ceph::combined':
      iscompute => true,
  }
  # If you want to run ceph mon0 on your controller node, uncomment the 
  #   following block. Be sure to read all additional ceph-related 
  #   instruction in this file.
  # only mon0 should export the admin keys.
  # This means the following if statement is not needed on the additional
  #  mon nodes.
    if !empty($::ceph_admin_key) {
    @@ceph::key { 'admin':
      secret       => $::ceph_admin_key,
      keyring_path => '/etc/ceph/keyring',
    }
    }


  ceph::osd::device { '/dev/sdb': }


  # each MON needs a unique id, you can start at 0 and increment as needed.
    class {'ceph_mon': id => 0 }
    class { 'ceph::apt::ceph': release => $::ceph_release }

}

# Change compute-server01 to the host name of your first compute node.
# Note that the hostname should be in all lowercase letters due to a
# limitation of Puppet (refer to http://projects.puppetlabs.com/issues/1168).
node 'compute-server01' inherits os_base {
  class { 'compute':
    internal_ip => '192.168.1.4',
    tunnel_ip   => '192.168.1.4',
  }
  if $::cinder_ceph_enabled {
    class { 'coe::ceph::compute':
      poolname => $::cinder_rbd_pool,
    }
  }
}

### Repeat as needed ###
# Copy the compute-server01 line above and paste a copy here for each
# additional OpenStack node in your cluster. Be sure to replace the
# 'compute-server01' parameter with the correct host name for each
# additional node.

# Defining cinder storage nodes is only necessary if you want to run
# cinder volume servers aside from those already on the compute nodes. To
# do so, create a node entry for each cinder-volume node following this model.
#node 'cinder-volume01' inherits os_base {
#  class { 'cinder_node': }
  # the volume class can be changed to different drivers (eg iscsi, rbd)
  # if you are targeting multiple backends using different driver on different
  # hosts, you will need to explicitly define your storage nodes

  # if you are using iscsi as your storage type, uncomment the following class
  #   and use a facter readable address for the interface that iscsi should use
  #   eg. $::ipaddress, or for a specific interface $::ipaddress_eth0 etc.
  #class { 'cinder::volume::iscsi':
  #  iscsi_ip_address => $::ipaddress,
  #}
#}

# Swift Proxy
# Adjust the value of swift_local_net_ip to match the IP address
# of your first Swift proxy node.  It is generally not necessary
# to modify the value of keystone_host, as it will default to the
# address of your control node.
node 'swift-proxy' inherits os_base {
  class {'openstack::swift::proxy':
    swift_local_net_ip     => $swift_proxy_address,
    swift_proxy_net_ip     => $swift_proxy_address,
    keystone_host          => $controller_node_address,
    controller_node_address => $controller_node_address,
    swift_user_password    => $swift_password,
    swift_hash_suffix      => $swift_hash,
  }
}

# Swift Storage
# Modify the swift_local_net_ip parameter to match the IP address of
# your Swift storage nodes.  Modify the storage_devices parameter
# to set the list of disk devices to be formatted with XFS and used
# for Swift storage.  Our deployment model requires a minimum of 3 
# storage nodes, but it is recommended to use at least 5 storage nodes
# (to support 5 zones) for production deployments.
node 'swift-storage01' inherits os_base {
  class {'openstack::swift::storage-node':
    swift_zone         => '1',
    swift_local_net_ip => '192.168.1.6',
    storage_type       => 'disk',
    storage_devices    => ['sdb'],
    swift_hash_suffix  => $swift_hash,
  }
}

node 'swift-storage02' inherits os_base {
  class {'openstack::swift::storage-node':
    swift_zone         => '2',
    swift_local_net_ip => '192.168.1.7',
    storage_type       => 'disk',
    storage_devices    => ['sdb'],
    swift_hash_suffix  => $swift_hash,
  }
}

node 'swift-storage03' inherits os_base {
  class {'openstack::swift::storage-node':
    swift_zone         => '3',
    swift_local_net_ip => '192.168.1.8',
    storage_type       => 'disk',
    storage_devices    => ['sdb'],
    swift_hash_suffix  => $swift_hash,
  }
}

### Repeat as needed ###
# Copy the swift-storage01 node definition above and paste a copy here for
# each additional OpenStack swift storage node in your cluster.  Modify
# the node name, swift_local_net_ip, and storage_devices parameters
# accordingly.

# Ceph storage
# For each OSD you need to specify the public address and the cluster address
# the public interface is used by the ceph client to access the service
# the cluster (management) interface can be the same as the public address
# if you have only one interface. It's recommended you have a separate 
# management interface.  This will offload replication and heartbeat from 
# the public network.
# When reloading an OSD, the disk seems to retain some data that needs to 
# be wiped clean. Before reloading the node, you MUST remove the OSD from 
# the running configuration. Instructions on doing so are located here:
#  http://ceph.com/docs/master/rados/operations/add-or-rm-osds/#removing-osds-manual
# Once complete, reinstall the node. Then, before running the puppet agent 
# on a reloaded OSD node, format the filesystem to be used by the OSD. Then
# delete the partition, delete the partition table, then dd /dev/zero to the
# disk itself, for a reasonable count to clear any remnant disk info.
# ceph MONs must be configured so a quorum can be obtained. You can have 
# one mon, and three mons, but not two, since no quorum can be established.
# No even number of MONs should be used.

# Configuring Ceph
#
# ceph_auth_type: you can specify cephx or none, but please don't actually 
# use none.
#
# ceph_monitor_fsid: ceph needs a cluster fsid. you can generate this on the
# CLI by running 'uuidgen -r'
#
# ceph_monitor_secret: mon hosts need a secret. This must be generated on
# a host with ceph already installed.  Create one by running 
# 'ceph-authtool --create /path/to/keyring --gen-key -n mon.:'
#
# ceph_monitor_port: the port that ceph MONs will listen on. 6789 is default.
#
# ceph_monitor_address: corresponds to the facter IP info. Change this to
# reflect your public interface.
#
# ceph_cluster_network: the network mask of your cluster (management)
# network (can be identical to the public netmask).
#
# ceph_public_network: the network mask of your public network.
#
# ceph_release: specify the release codename to install the respective release.
#
# cinder_rbd_user: the user configured in ceph to allow cinder rwx access
# to the volumes pool.  This currently requires the name 'volumes'. Do not
# change it.
#
# cinder_rbd_pool: the name of the pool in ceph for cinder to use for
# block device creation.  This currently requires the name 'volumes'. Do 
# not change it.
#
# cinder_rbd_secret_uuid: the uuid secret to allow cinder to communicate
# with ceph.  This MUST be left as the string 'REPLACEME'. The actual UUID 
# is unique and is generated only after ceph is installed. It is injected
# during the puppet run.

$ceph_auth_type         = 'cephx'
$ceph_monitor_fsid      = 'e80afa94-a64c-486c-9e34-d55e85f26406'
$ceph_monitor_secret    = 'AQAJzNxR+PNRIRAA7yUp9hJJdWZ3PVz242Xjiw=='
$ceph_monitor_port      = '6789'
$ceph_monitor_address   = $::ipaddress
$ceph_cluster_network   = '192.168.242.0/24'
$ceph_public_network    = '192.168.242.0/24'
$ceph_release           = 'cuttlefish'
$cinder_rbd_user        = 'admin'
$cinder_rbd_pool        = 'volumes'
$cinder_rbd_secret_uuid = 'REPLACEME'

# This global path needs to be uncommented for puppet-ceph to work.
# Uncomment and define the proxy server if your nodes don't have direct
# access to the internet. This is due to apt needing to run a wget.
Exec {
  path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
#  environment => "https_proxy=$::proxy",
}


node 'ceph-mon01' inherits os_base {
  # only mon0 should export the admin keys.
  # This means the following if statement is not needed on the additional
  #  mon nodes.
  if !empty($::ceph_admin_key) {
  @@ceph::key { 'admin':
    secret       => $::ceph_admin_key,
    keyring_path => '/etc/ceph/keyring',
  }
  }

  # each MON needs a unique id, you can start at 0 and increment as needed.
  class {'ceph_mon': id => 0 }
  class { 'ceph::apt::ceph': release => $::ceph_release }
}



# This is the OSD node definition example. You will need to specify the
# public and cluster IP for each unique node.

node 'ceph-osd01' inherits os_base {
  class { 'ceph::conf':
    fsid            => $::ceph_monitor_fsid,
    auth_type       => $::ceph_auth_type,
    cluster_network => $::ceph_cluster_network,
    public_network  => $::ceph_public_network,
  }
  class { 'ceph::osd':
    public_address  => '192.168.1.11',
    cluster_address => '192.168.1.11',
  }
  # Specify the disk devices to use for OSD here.
  # Add a new entry for each device on the node that ceph should consume.
  # puppet agent will need to run four times for the device to be formatted,
  #   and for the OSD to be added to the crushmap.
  ceph::osd::device { '/dev/sdb': }
  class { 'ceph::apt::ceph': release => $::ceph_release }
}

node 'ceph-osd02' inherits os_base {
  class { 'ceph::conf':
    fsid            => $::ceph_monitor_fsid,
    auth_type       => $::ceph_auth_type,
    cluster_network => $::ceph_cluster_network,
    public_network  => $::ceph_public_network,
  }
  class { 'ceph::osd':
    public_address  => '192.168.1.12',
    cluster_address => '192.168.1.12',
  }
  # Specify the disk devices to use for OSD here.
  # Add a new entry for each device on the node that ceph should consume.
  # puppet agent will need to run four times for the device to be formatted,
  #   and for the OSD to be added to the crushmap.
  ceph::osd::device { '/dev/sdb': }
  class { 'ceph::apt::ceph': release => $::ceph_release }
}

node 'ceph-osd03' inherits os_base {
  class { 'ceph::conf':
    fsid            => $::ceph_monitor_fsid,
    auth_type       => $::ceph_auth_type,
    cluster_network => $::ceph_cluster_network,
    public_network  => $::ceph_public_network,
  }
  class { 'ceph::osd':
    public_address  => '192.168.1.13',
    cluster_address => '192.168.1.13',
  }
  # Specify the disk devices to use for OSD here.
  # Add a new entry for each device on the node that ceph should consume.
  # puppet agent will need to run four times for the device to be formatted,
  #   and for the OSD to be added to the crushmap.
  ceph::osd::device { '/dev/sdb': }
  class { 'ceph::apt::ceph': release => $::ceph_release }
}

### End repeated nodes ###

########################################################################
### All parameters below this point likely do not need to be changed ###
########################################################################

### Advanced Users Configuration ###
# These four settings typically do not need to be changed.
# In the default deployment, the build node functions as the DNS and static
# DHCP server for the OpenStack nodes. These settings can be used if
# alternate configurations are needed.
$node_dns       = "${cobbler_node_ip}"
$ip             = "${cobbler_node_ip}"
$dns_service    = 'dnsmasq'
$dhcp_service   = 'dnsmasq'
$time_zone      = 'UTC'

# Enable network interface bonding. This will only enable the bonding module
# in the OS. It won't actually bond any interfaces. Edit the networking
# interfaces template to set up interface bonds as required after setting
# this to true should bonding be required.
#$interface_bonding = 'true'

# Enable ipv6 router advertisement.
#$ipv6_ra = '1'

# Adjust Quantum quotas
# These are the default Quantum quotas for various network resources.
# Adjust these values as necessary. Set a quota to '-1' to remove all
# quotas for that resource. Also, keep in mind that Nova has separate
# quotas which may also apply as well.
#
# Number of networks allowed per tenant
$quantum_quota_network             = '10'
# Number of subnets allowed per tenant
$quantum_quota_subnet              = '10'
# Number of ports allowed per tenant
$quantum_quota_port                = '50'
# Number of Quantum routers allowed per tenant
$quantum_quota_router              = '10'
# Number of floating IPs allowed per tenant
$quantum_quota_floatingip          = '50'
# Number of Quantum security groups allowed per tenant
$quantum_quota_security_group      = '10'
# Number of security rules allowed per security group
$quantum_quota_security_group_rule = '100'

# Configure the maximum number of times mysql-server will allow
# a host to fail connecting before banning it.
$max_connect_errors = '10'

### modify disk partitioning ###
# set expert_disk to true if you want to specify partition sizes,
#  of which root and var are currently supported
# if you do not want a separate /var from /, set enable_var to false
# if you do not want extra disk space set aside in an LVM volume
#  then set enable_vol_space to false (you likely want this true if you
#  want to use iSCSI CINDER on the compute nodes, and you must set
#  expert_disk to true to enable this.

$expert_disk           = true
$root_part_size        = 65536
$var_part_size         = 1048576
$enable_var            = true
$enable_vol_space      = true

# Select vif_driver and firewall_driver for quantum and quantum plugin
# These two parameters can be changed if necessary to support more complex
# network topologies as well as some Quantum plugins.
# These default values are required for Quantum security groups to work
# when using Quantum with OVS.
$libvirt_vif_driver      = 'nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver'
$quantum_firewall_driver = 'quantum.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver'
# If you don't want Quantum security groups when using OVS, comment out the
# libvirt_vif_driver line above and uncomment the libvirt_vif_driver below
# instead
# $libvirt_vif_driver = 'nova.virt.libvirt.vif.LibvirtGenericVIFDriver'

### Puppet Parameters ###
# These settings load other puppet components. They should not be changed.
import 'cobbler-node'
import 'core'

## Define the default node, to capture any un-defined nodes that register
## Simplifies debug when necessary.

node default {
  notify{'Default Node: Perhaps add a node definition to site.pp': }
}
