#!/usr/bin/env bash

# start with no machines
vagrant destroy -f
rm -rf .vagrant

#time vagrant up --provider virtualbox 2>&1 | tee virtualbox-build-output.log
vagrant up --provider virtualbox
vagrant halt
vagrant package --base `ls ~/VirtualBox\ VMs | grep settler` --output virtualbox.box

ls -lh virtualbox.box
vagrant destroy -f
rm -rf .vagrant

#time vagrant up --provider vmware_fusion 2>&1 | tee vmware-build-output.log
vagrant up --provider vmware_fusion
vagrant halt
# defrag disk (assumes running on osx)
/Applications/VMware\ Fusion.app/Contents/Library/vmware-vdiskmanager -d .vagrant/machines/default/vmware_fusion/*-*-*-*-*/disk.vmdk
# shrink disk (assumes running on osx)
/Applications/VMware\ Fusion.app/Contents/Library/vmware-vdiskmanager -k .vagrant/machines/default/vmware_fusion/*-*-*-*-*/disk.vmdk
# 'vagrant package' does not work with vmware boxes (http://docs.vagrantup.com/v2/vmware/boxes.html)
cd .vagrant/machines/default/vmware_fusion/*-*-*-*-*/
rm -f vmware*.log
tar cvzf ../../../../../vmware_fusion.box *
cd ../../../../../

ls -lh vmware_fusion.box
vagrant destroy -f
rm -rf .vagrant
