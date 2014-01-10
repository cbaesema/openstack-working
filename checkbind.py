#!/usr/bin/env python

import os

def cmd_exec(cmd):
  return str(os.system(cmd))


if cmd_exec('netstat -an | grep 0.0.0.0:6080').find('LISTEN'):
  if os.path.exists('/etc/init.d/nova-novncproxy')
    cmd_exec('/usr/sbin/service nova-novncproxy restart')


#if cmd_exec('netstat -an | grep 0.0.0.0:6080').find('LISTEN'):
#  if os.path.exists('/etc/init.d/nova-novncproxy')
#    cmd_exec('/usr/sbin/service nova-novncproxy restart')
