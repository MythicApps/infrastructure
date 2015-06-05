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
}

user { 'badsauce':
  ensure     => present,
  groups     => ['sudo'],
  managehome => true,
  shell      => '/bin/bash',
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
ssh_authorized_key { 'rutowsk1@msu.edu':
  user => 'badsauce',
  type => 'ssh-rsa',
  key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCy8BoYSpvCS4Vxil/yFttnVJJlRMQ7Rdexxk0vQ9GGM7NT5J2TPIx1nAu7d56zY2Ocb3Q/tJ7etepJIdvWUrRhBC2Hr/mVBF/puz8EEr9QhRoFjMJQY33oRlBjkXKGdO4J6xHSED/U2SuRV8CtDTVNOctB2Ybi0Tq95A9ZRvs0mMQLP2iF6SYmjO0OObsk26OAy8MBk1zuVytFMdA727APtdAOgWbzoVfQQE6ckkn4PZoz6vcc4q+MEEN/5j9h2vQ0mX0W9DgFBSU0YPv5YU/lJCZsVUgaoyALo06EK/2HyvVFCJOF2G/jebZ/tQgCVtu3Rt7Fo26XghiK/Le+MNzJ',
}

ssh_authorized_key { 'nickrutowski@gmail.com':
  user => 'badsauce',
  type => 'ssh-rsa',
  key  => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQC+HtC0hDyWfKHL0joTCbaq+quMEp+NJtxqsGvmOXW55OSwP9Y71oScw4DM3fufxcE0RJIM+6kZ7wlVJyoVAZZkRxBMv2i4e6e6fUf35vmKnVjuqz0ndMKR7tgRM6NX+yHn66eZxiiYWI3pD9s5C9Pq6Dn+SjJFWY7D4ajbdcBA3uM+hLYr5ujB1J04p1YdHm9Pek54bSsROyzsX1hnQWystH4oafCIyZtoK30z7QeTOHpi/KOC0z5hM1PxCYA5MI+gjzf6qDBMREgWjfxi2c9jhfxmmgKU8mG9zxtcrrs2cS85BPy6VGmUWB6sOf+tOj0R2XpYh+eZ7B6EnTGltUnpxXImQapOZ6blmagsl4biNQQf2cddz2vtcfrCD5d5h/9htEHaLMwjfvej67C2E5BhlsT3qmg3iqqeiLrzZ4QPnFuULZwzydq0NMTSJ1RvX1D+xtW6JJIT7nhYFDet78MAeQEEKCXUU7RxPQGZn4ESqnqBvi0OD0MEypp5DLGQ2pxmqfz+8rZCkq8hQlFxBBRl2ju/i4i8HO7jjKMgeRcVWSJk2nB3nr2lP428iQJkAtGBKKS4sAL/aiTfK4c3GJAAR3sJZJtpk5V/bKJJe3CKHw9N71+mCd7vXONK/nyUFUgZRBoCCzWIHOAH5BZWL42Eo9wBxB2QUsNJfVHOpqE7Ow==',
}
