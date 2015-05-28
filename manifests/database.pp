import 'default.pp'

# PACKAGES

# MODULES
class { 'postgresql::server': }

postgresql::server::db { 'mythiccms':
  user => 'mythicdjango',
}
