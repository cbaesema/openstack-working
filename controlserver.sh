#!/bin/bash
hostname control-server
./setproposed.py
cd /etc/puppet/manifests
./puppet_modules.py
puppet apply -v site.pp
