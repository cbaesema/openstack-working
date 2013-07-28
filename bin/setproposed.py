#!/usr/bin/env python


fp = open('/etc/puppet/manifests/puppet_modules.py')
lines = fp.readlines()
fp.close()
fp = open('/etc/puppet/manifests/puppet_modules.py','w')
for line in lines:
    if line.startswith('REPO_NAME'):
       fp.write(line.replace('grizzly','grizzly-proposed'))
    else:
        fp.write(line)
fp.close()
         
             
fp = open('/etc/puppet/manifests/core.pp')
lines = fp.readlines()
fp.close()
fp = open('/etc/puppet/manifests/core.pp','w')
for line in lines:
    if 'release' in line:
       fp.write(line.replace('grizzly','grizzly-proposed'))
    else:
        fp.write(line)
fp.close()
        
