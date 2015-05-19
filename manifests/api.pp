import 'default.pp'

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
exec { 'install ensurepip':
  command => '/usr/bin/python3.4 /tmp/files/install_ensurepip.py',
}

python::pyvenv { '/home/api/www' :
  ensure   => present,
  version  => '3.4',
  venv_dir => '/home/api/virtualenvs',
  owner    => 'api',
  group    => 'api',
  require  => Exec['install ensurepip'],
}
