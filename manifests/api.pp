import 'default.pp'

package { ['libpq-dev', 'libmysqlclient-dev']: }

include 'git'

user { 'api':
  ensure     => present,
  managehome => true,
}
file { '/home/api/conf':
  ensure => directory,
  owner  => 'api',
}

# not idempotent; should use modules so we could use File resources with source
exec { 'copy configs':
  command => '/bin/cp /tmp/files/*api* /home/api/conf',
  user    => 'api',
  require => [
    User['api'],
    File['/home/api/conf']
  ],
}

vcsrepo { '/home/api/www':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/MythicApps/MythicAppsSite.git',
  owner    => 'api',
  group    => 'api',
  require  => User['api'],
}

class { 'python' :
  pip        => true,
  version    => '3.4',
  dev        => true,
  virtualenv => true,
}

# Ubuntu 14.04 has a broken python 3.4 install; need to add ensurepip
# hacked idempotent
exec { 'install ensurepip':
  command => '/usr/bin/python3.4 /tmp/files/install_ensurepip.py',
  creates => '/usr/lib/python3.4/ensurepip',
}

python::pyvenv { '/home/api/www' :
  ensure   => present,
  version  => '3.4',
  venv_dir => '/home/api/virtualenvs',
  owner    => 'api',
  group    => 'api',
  require  => [
    Exec['install ensurepip'],
    Vcsrepo['/home/api/www'],
  ],
}

python::requirements { '/home/api/www/requirements.txt' :
  virtualenv  => '/home/api/virtualenvs',
  owner       => 'api',
  group       => 'api',
  forceupdate => true,  # not idempotent; but need to make it work
  require     => [
    Package['libpq-dev'],
    Package['libmysqlclient-dev'],
  ],
}

python::pip { 'uwsgi' :
  pkgname      => 'uwsgi',
  virtualenv   => '/home/api/virtualenvs',
  owner        => 'api',
  timeout      => 1800,
}

file { '/home/api/tmp':
  ensure => directory,
  owner  => 'api',
}

# not idempotent; needs to run everytime to catch updates; make module
exec { 'uwsgi upstart':
  command  => '/bin/cp /tmp/files/uwsgi.conf.api /etc/init/uwsgi.conf',
  require  => [
    File['/home/api/tmp'],
    Python::Pip['uwsgi'],
  ],
}

service { 'uwsgi':
  ensure => running,
  require => [
    Exec['uwsgi upstart'],
  ],
}

vcsrepo { '/home/api/deploy':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/logsol/Github-Auto-Deploy.git',
  owner    => 'api',
  group    => 'api',
  require  => User['api'],
}

exec { 'deploy config':
  command => '/bin/cp /tmp/files/GitAutoDeploy.conf.json.api /home/api/deploy/GitAutoDeploy.conf.json',
  user    => 'api',
  require => [
    User['api'],
    Vcsrepo['/home/api/deploy'],
  ],
}

exec { 'start deploy server':
  command => '/bin/bin/python GitAutoDeploy.py --daemon-mode',
  user    => 'api',
  cwd     => '/home/api/deploy',
  unless  => '/usr/bin/pgrep -fc "GitAutoDeploy"',
  require => [
    Exec['deploy config'],
    User['api'],
  ],
}
