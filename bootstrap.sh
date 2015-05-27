#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
  echo "This script must be run as root"
  exit
fi

while getopts "spqm:" o; do
  case "${o}" in
    s)
      SETUP=true
      ;;
    p)
      PRODUCTION=true
      ;;
    m)
      MANIFEST=${OPTARG}
      ;;
    q)
      QUICK=true
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

usage() { echo "Usage: $0 [-s]" 1>&2; exit 1; }

create-swap-file () {
  dd if=/dev/zero of=/swapfile bs=1024 count=512k
  mkswap /swapfile
  swapon /swapfile
}

install-pre-requisites () {
  apt-get update
  apt-get install build-essential ruby-dev -y
}


install-puppet () {
  cd /tmp
  wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
  dpkg -i puppetlabs-release-precise.deb
  apt-get update
  apt-get install puppet -y
  sed -i '/templatedir=/d' /etc/puppet/puppet.conf
}

install-librarian-puppet () {
  gem install librarian-puppet --no-ri --no-rdoc
}

prepare-manifest () {
  cd /tmp
  rm -rf puppet/
  tar xozf puppet-code.tgz
  tar xozf files.tgz
  cd puppet/
}

install-modules() {
  librarian-puppet install
}

run-manifest () {
  cd /tmp/puppet
  puppet apply --modulepath=modules manifests/$MANIFEST.pp
}

run-production-manifest () {
  cd /tmp/puppet
  puppet apply --modulepath=modules manifests/sudo.pp
}

main () {
  if [ "$SETUP" = true ]; then
    echo "SETUP"
    create-swap-file
    install-pre-requisites
    install-puppet
    install-librarian-puppet
  fi

  prepare-manifest

  if [ ! "$QUICK" = true ]; then
  echo "NOT QUICK"
    install-modules
  fi

  run-manifest

  if [ "$PRODUCTION" = true ]; then
    echo "PRODUCTION"
    run-production-manifest
  fi
}

main
