#!/bin/bash
moddir='/tmp/vagrant-puppet/environments/vagrant/modules'
modules=( 'puppetlabs/stdlib' )
[ -d ${moddir} ] || mkdir ${moddir}
for module in "${modules[@]}"
do
  [ -d ${moddir}/${module##*/} ] ||
    puppet module install $module --force --target-dir ${moddir}/
done
