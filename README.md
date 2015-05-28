# MythicApps Infrastructure

## Description

Repository for the development of the servers powering Mythic Apps.

## Requirements

* Virtual Box
* Vagrant
* Linux / MacOSX (possible with coreutils): Currently relies on Make which is
  not available on Windows. Can be platform independent if someone writes code
  to handle the making and deploying to the virtual machine .
* Librarian Puppet: If you want to update the Puppetfile

## Development

* Clone this repository
* Start the virtual machine: `vagrant up`
* Copy the configuration over: `make dev-deploy`
* Connect to the virtual machine: `vagrant ssh`
* Run the configuration files:

```
sudo su
cd /tmp
bash bootstrap.sh -s -m default
```

Only use the -s flag if this is your initial run on the virtual machine.

The -m flag specifies the manifest to run.  (default, proxy, api)

## Deployment

* Clone this repository
* Copy the configuration to the virtual machine: `USER=root HOST=api.mythicapps.io make deploy`
* Connect to the virtual machine: `ssh api.mythicapps.io`
* Run the configuration code:

```
sudo su
cd /tmp
bash bootstrap.sh -s -m api -p
```

The -p flag is used for production.  This runs some extra configuration
