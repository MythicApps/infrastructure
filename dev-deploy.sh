#!/bin/bash
OPTIONS=`vagrant ssh-config | grep -v '^Host ' | awk -v ORS=' ' '{print "-o " $1 "=" $2}'`

scp ${OPTIONS} bootstrap.sh vagrant@192.168.111.10:/tmp
scp ${OPTIONS} tmp/puppet-code.tgz vagrant@192.168.111.10:/tmp
scp ${OPTIONS} tmp/files.tgz vagrant@192.168.111.10:/tmp
