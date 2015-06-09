import 'default.pp'

# MODULES
class { 'nginx': }

nginx::resource::upstream { 'api':
  members => [
    'api-prd-1.mythicapps.io:8080',
  ],
}
nginx::resource::upstream { 'static':
  members => [
    'static-prd-1.mythicapps.io:3000',
  ],
}

nginx::resource::vhost { 'api.mythicapps.io':
  proxy => 'http://api',
}

nginx::resource::vhost { 'mythicapps.io-non-www':
  ensure              => present,
  server_name         => ['mythicapps.io', 'www.mythicapps.io'],
  proxy               => 'http://static',
  location_cfg_append => {
      'rewrite' => '^ https://mythicapps.io$request_uri? permanent'
  },
}

nginx::resource::vhost { 'www.mythicapps.io':
  ensure              => present,
  listen_port         => 443,
  proxy               => 'http://static',
  location_cfg_append => {
      'rewrite' => '^ https://mythicapps.io$request_uri? permanent'
  },
  ssl         => true,
  ssl_cert    => '/etc/ssl/certs/www.mythicapps.io-bundle.crt',
  ssl_key     => '/etc/ssl/private/www.mythicapps.io.key',
}

nginx::resource::vhost { 'mythicapps.io':
  ensure      => present,
  proxy       => 'http://static',
  listen_port => 443,
  ssl         => true,
  ssl_cert    => '/etc/ssl/certs/www.mythicapps.io-bundle.crt',
  ssl_key     => '/etc/ssl/private/www.mythicapps.io.key',
}
