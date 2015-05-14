# PACKAGES
package { 'zsh': }


# MODULES
class { 'ssh':
  storeconfigs_enabled       => false,
  server_options             => {
    'PasswordAuthentication' => 'no',
    'PermitRootLogin'        => 'no',
  },
}


# USERS
user { 'atomaka':
  ensure     => present,
  groups     => ['sudo'],
  managehome => true,
  shell      => '/bin/zsh',
  require    => [
    Package['zsh'],
  ],
}

user { 'tec':
  ensure => present,
  groups => ['sudo'],
  managehome => true,
  shell      => '/bin/bash',
  require    => [
    Package['zsh'],
  ],
}

# KEYS
ssh_authorized_key { 'atomaka@gmail.com':
  user => 'atomaka',
  type => 'ssh-rsa',
  key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDRwQ+1wZ4rSIQyAOG/G+4c9tKO4h716hQEiD95hw44TIQ4rdU1xqStEdV+vLgHpk/vFDC1gNlesRGh/PynEObPIbUdAypnSIg6qfLGCD0HcyGqU6dxzynQ8tgA23qLLMxGMG7kPjxSk3LVY6u+I/KHqArJjDqXcns7kN26LimJt4azHBI165Z7q+xuOtgDApdRecyvkIcjrl1oveHjOnVTZl1l78fqr1nTmvHkkeWGHxdM2IE2eFxGEpb6yyjNzxpX8JsFFXJiuq+fa+1Xj7dA3QZjV+BWUfhj2LSoOfWRgxy4oUhxfbDbOC+pBFWEKA1lDnRZ+nBIw1nXmF7hpBOx',
}

ssh_authorized_key { 'tomcummings@gmail.com':
  user => 'tec',
  type => 'ssh-rsa',
  key  => 'AAAAB3NzaC1yc2EAAAABJQAAAIEAzi0WAsaqWAsndFP8EAS0ImJNh9xGd+uczW4Iw3pIg2lyHAG/SOmUn0O6DD2emiopH7LwKo6qcmytosq15PAHNdxJ+RRJJ7atKxDx/GC4JOHDrp+nZ3nta40pXLBzh6I2zh6H9Bic63JGFjc4q07DrxUkx0G+1vQcOVa5agcp9QU=',
}
