import 'default.pp'

# MODULES
class { 'nginx': }

nginx::resource::upstream { 'rails':
  members => [
    'rails-prd-1.mythicapps.io:80',
  ],
}

nginx::resource::vhost { 'mythicapps.io-non-www':
  ensure              => present,
  server_name         => ['mythicapps.io', 'www.mythicapps.io'],
  proxy               => 'http://rails',
  location_cfg_append => {
      'rewrite' => '^ https://mythicapps.io$request_uri? permanent'
  },
}

nginx::resource::vhost { 'www.mythicapps.io':
  ensure              => present,
  listen_port         => 443,
  proxy               => 'http://rails',
  location_cfg_append => {
      'rewrite' => '^ https://mythicapps.io$request_uri? permanent'
  },
  ssl         => true,
  ssl_cert    => '/etc/ssl/certs/www.mythicapps.io-bundle.crt',
  ssl_key     => '/etc/ssl/private/www.mythicapps.io.key',
}

nginx::resource::vhost { 'mythicapps.io':
  ensure      => present,
  proxy       => 'http://rails',
  listen_port => 443,
  ssl         => true,
  ssl_cert    => '/etc/ssl/certs/www.mythicapps.io-bundle.crt',
  ssl_key     => '/etc/ssl/private/www.mythicapps.io.key',
}
