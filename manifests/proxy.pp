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
    'static-prd-1.mythicapps.io',
  ],
}

nginx::resource::vhost { 'api.mythicapps.io':
  proxy => 'http://api',
}

nginx::resource::vhost { 'static.mythicapps.io':
  proxy => 'http://static',
}

nginx::resource::vhost { 'www.mythicapps.io':
  proxy => 'http://static',
}

nginx::resource::vhost { 'mythicapps.io':
  proxy => 'http://static',
}
