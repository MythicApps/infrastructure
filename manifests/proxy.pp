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

nginx::resource::vhost { 'mythicapps.io':
  server_name => ['mythicapps.io', 'www.mythicapps.io'],
  proxy       => 'http://static',
  ssl         => true,
  ssl_cert    => '/etc/ssl/certs/www.mythicapps.io-bundle.crt',
  ssl_key     => '/etc/ssl/private/www.mythicapps.io.key',
}
