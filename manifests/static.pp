import 'default.pp'

# MDOULES
include 'git'
class { 'nginx': }

user { 'static':
  ensure     => present,
  managehome => true,
}

nginx::resource::vhost { 'static-prd-1.mythicapps.io':
  www_root => '/var/www/static.mythicapps.io',
}

vcsrepo { '/var/www/static.mythicapps.io':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/MythicApps/Mythic-Apps-Public-Web.git',
  owner    => 'static',
  group    => 'static',
  require  => User['static'],
}

vcsrepo { '/home/static/deploy':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/logsol/Github-Auto-Deploy.git',
  owner    => 'static',
  group    => 'static',
  require  => User['static'],
}

exec { 'deploy config':
  command => '/bin/cp /tmp/files/GitAutoDeploy.conf.json.static /home/static/deploy/GitAutoDeploy.conf.json',
  user    => 'static',
  require => [
    User['static'],
    Vcsrepo['/home/static/deploy'],
  ],
}

exec { 'start deploy server':
  command => '/usr/bin/python GitAutoDeploy.py --daemon-mode',
  user    => 'static',
  cwd     => '/home/static/deploy',
  unless  => '/usr/bin/pgrep -fc "GitAutoDeploy"',
  require => Exec['deploy config'],
}
