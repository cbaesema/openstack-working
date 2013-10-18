#!/bin/bash
apt-get install rubygems
cd /opt
rm -rf /opt/vendor
mkdir -p vendor
export GEM_HOME=`pwd`/vendor
gem install thor --no-ri --no-rdoc
git clone git://github.com/bodepd/librarian-puppet-simple vendor/librarian-puppet-simple
export PATH=`pwd`/vendor/librarian-puppet-simple/bin/:$PATH
cd /etc/puppet
librarian-puppet install --verbose --puppetfile=/opt/openstack-installer/Puppetfile
rm -rf /etc/puppet/data
ln -s /opt/openstack-installer/data /etc/puppet/data

