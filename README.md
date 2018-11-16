# PCF Helper Scripts

This is a set of scripts to help with the install and daily mgmt of PCF. 

# Setup

1. fill in the values for the `pcfsrc` file
2. `source pcfsrc`
3. run the script of your choosing 

# Scripts

## [install-om-pivnet.sh](opsman/install-om-pivnet.sh)

#### Description
this script will install the [om cli](https://github.com/pivotal-cf/om) as well as the [pivnet cli](https://github.com/pivotal-cf/pivnet-cli)

#### Params:
NA

#### Usage:

`./opsman/install-om-pivnet.sh`

## [upload-stemcell.sh](opsman/upload-stemcell.sh)

#### Description
downloads a stemcell from pivnet and uploads it to the ops manager. this is current set up to run from ops manager since the uplaod is much faster.

#### Params:
1. file-name - name to download the file as. must end in `.tgz`
2. api-url - the url from  pivnet

#### Usage:

`./opsman/upload-stemcell.sh <file-name> <api-url>`

## [upload-tile.sh](opsman/upload-tile.sh)

#### Description
downloads a tile from pivnet and uploads it to the ops manager. this is current set up to run from ops manager since the uplaod is much faster. this will also handle the PASW(PAS for windows) tile by adding the extra step of running the `winfs-injector` step. 

#### Params:
1. file-name - name to download the file as. 
2. api-url - the url from  pivnet

#### Usage:

`./opsman/upload-tile.sh <file-name> <api-url>`

## [generate-cert.sh](openssl/generate-cert.sh)

#### Description
this will generate a self signed SAN cert for the domains needed to run the platform. 

#### Params:
the neccessary params for this will come from the pcfsrc. 

#### Usage:

`./openssl/generate-cert.sh`

## [create-user.sh](vmware/create-user.sh)

#### Description
this will use govc to create a user, role and attach the role to the user in vsphere. these permissions are based on [this doc](https://docs.pivotal.io/pivotalcf/2-3/customizing/vsphere-service-account.html) 

#### Params:
the neccessary params for this will come from the pcfsrc. 
* `VSPHERE_USER_PASS`

#### Usage:
* set the above paramater value in the `pcfsrc`
* `source pcfsrc`
* `./vmware/create-user.sh`

