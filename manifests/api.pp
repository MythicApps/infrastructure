import 'default.pp'

package { ['libpq-dev', 'libmysqlclient-dev']: }

include 'git'

user { 'api':
  ensure     => present,
  managehome => true,
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

exec { 'uwsgi start':
  command => '/home/api/virtualenvs/bin/uwsgi --ini /tmp/files/api-uwsgi.ini',
  unless  => '/usr/bin/pgrep uwsgi',
  require => [
    Python::Pip['uwsgi'],
    File['/home/api/tmp'],
  ],
}

file { '/home/api/tmp':
  ensure => directory,
  owner  => 'api',
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
  command => '/usr/bin/python GitAutoDeploy.py --daemon-mode',
  user    => 'api',
  cwd     => '/home/api/deploy',
  unless  => '/usr/bin/pgrep -fc "GitAutoDeploy"',
  require => Exec['deploy config'],
}
