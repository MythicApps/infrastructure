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

# not executing (partially)
# need to run:
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
  require => Python::Pip['uwsgi'],
}
