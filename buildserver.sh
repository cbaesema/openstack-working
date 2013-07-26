#!/bin/bash
hostname build-server
./setproposed.py
cd /etc/puppet/manifests
puppet apply -v site.pp
