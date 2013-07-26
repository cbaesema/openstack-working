#!/bin/bash
hostname control-server
./setproposed.py
cd /etc/puppet/manifests
puppet apply -v site.pp
