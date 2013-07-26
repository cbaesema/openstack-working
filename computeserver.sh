#!/bin/bash
hostname compute-server
./setproposed.py
cd /etc/puppet/manifests
puppet apply -v site.pp
