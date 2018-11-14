#!/bin/sh
set -e
#permissions taken from https://docs.pivotal.io/pivotalcf/2-3/customizing/vsphere-service-account.html

govc sso.user.create -R RegularUser -p $VSPHERE_USER_PASS pcf_user

govc role.create pcf_role $(cat ./permissions.txt)

govc permissions.set -principal pcf_user@vsphere.local -role pcf_role