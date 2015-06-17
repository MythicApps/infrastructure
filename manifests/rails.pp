import 'default.pp'

include 'git'
class { 'rbenv': }

user { 'app':
  ensure     => present,
  managehome => true,
  groups     => ['sudo'],
  shell      => '/bin/bash',
}

ssh_authorized_key { 'app-atomaka@gmail.com':
  user => 'app',
  type => 'ssh-rsa',
  key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDRwQ+1wZ4rSIQyAOG/G+4c9tKO4h716hQEiD95hw44TIQ4rdU1xqStEdV+vLgHpk/vFDC1gNlesRGh/PynEObPIbUdAypnSIg6qfLGCD0HcyGqU6dxzynQ8tgA23qLLMxGMG7kPjxSk3LVY6u+I/KHqArJjDqXcns7kN26LimJt4azHBI165Z7q+xuOtgDApdRecyvkIcjrl1oveHjOnVTZl1l78fqr1nTmvHkkeWGHxdM2IE2eFxGEpb6yyjNzxpX8JsFFXJiuq+fa+1Xj7dA3QZjV+BWUfhj2LSoOfWRgxy4oUhxfbDbOC+pBFWEKA1lDnRZ+nBIw1nXmF7hpBOx',
}

ssh_authorized_key { 'app-rutowsk1@msu.edu':
  user => 'app',
  type => 'ssh-rsa',
  key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCy8BoYSpvCS4Vxil/yFttnVJJlRMQ7Rdexxk0vQ9GGM7NT5J2TPIx1nAu7d56zY2Ocb3Q/tJ7etepJIdvWUrRhBC2Hr/mVBF/puz8EEr9QhRoFjMJQY33oRlBjkXKGdO4J6xHSED/U2SuRV8CtDTVNOctB2Ybi0Tq95A9ZRvs0mMQLP2iF6SYmjO0OObsk26OAy8MBk1zuVytFMdA727APtdAOgWbzoVfQQE6ckkn4PZoz6vcc4q+MEEN/5j9h2vQ0mX0W9DgFBSU0YPv5YU/lJCZsVUgaoyALo06EK/2HyvVFCJOF2G/jebZ/tQgCVtu3Rt7Fo26XghiK/Le+MNzJ',
}

ssh_authorized_key { 'app-nickrutowski@gmail.com':
  user => 'app',
  type => 'ssh-rsa',
  key  => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQC+HtC0hDyWfKHL0joTCbaq+quMEp+NJtxqsGvmOXW55OSwP9Y71oScw4DM3fufxcE0RJIM+6kZ7wlVJyoVAZZkRxBMv2i4e6e6fUf35vmKnVjuqz0ndMKR7tgRM6NX+yHn66eZxiiYWI3pD9s5C9Pq6Dn+SjJFWY7D4ajbdcBA3uM+hLYr5ujB1J04p1YdHm9Pek54bSsROyzsX1hnQWystH4oafCIyZtoK30z7QeTOHpi/KOC0z5hM1PxCYA5MI+gjzf6qDBMREgWjfxi2c9jhfxmmgKU8mG9zxtcrrs2cS85BPy6VGmUWB6sOf+tOj0R2XpYh+eZ7B6EnTGltUnpxXImQapOZ6blmagsl4biNQQf2cddz2vtcfrCD5d5h/9htEHaLMwjfvej67C2E5BhlsT3qmg3iqqeiLrzZ4QPnFuULZwzydq0NMTSJ1RvX1D+xtW6JJIT7nhYFDet78MAeQEEKCXUU7RxPQGZn4ESqnqBvi0OD0MEypp5DLGQ2pxmqfz+8rZCkq8hQlFxBBRl2ju/i4i8HO7jjKMgeRcVWSJk2nB3nr2lP428iQJkAtGBKKS4sAL/aiTfK4c3GJAAR3sJZJtpk5V/bKJJe3CKHw9N71+mCd7vXONK/nyUFUgZRBoCCzWIHOAH5BZWL42Eo9wBxB2QUsNJfVHOpqE7Ow==',
}

file { '/home/app/mythicapps':
  ensure  => directory,
  owner   => 'app',
  group   => 'app',
  require => User['app'],
}

exec { 'copy configs':
  command => '/bin/cp /tmp/files/.bashrc.app /home/app/.bashrc',
  user    => 'app',
  require => User['app'],
}

# need update before nodejs install
package { ['nginx', 'libpq-dev', 'nodejs']: }

rbenv::plugin { 'sstephenson/ruby-build': }
rbenv::build { '2.1.5': global => true }
# following causes duplicate bundler install, but also can't find bundler as
# user. Manual install to circumvent for now with "gem install bundler"
# Maybe try rehash or something next time
#rbenv::gem { 'bundler': ruby_version =>'2.1.5' }
