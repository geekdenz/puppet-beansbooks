# == Class: beansbooks::config
#
#
# === Parameters
#
# === Variables
#
#
# === Examples
#
#
# === Copyright
#
# GPL-3.0+
#
class beansbooks::config {

  anchor{'beansbooks::config::begin':}


  ## configure postgresql
  postgresql::server::db { 'beansbooks':
    user     => $beansbooks::db_user,
    password => postgresql_password($beansbooks::db_user, $beansbooks::db_pass),
    ## utf8 ??
    #require  => Apache::Vhost['beansbooks'],
    require       => Anchor['beansbooks::config::begin'],
  }

#  exec {'web install':
#    command => "php index.php --uri=/install/manual --name='Your Name' --password='password' --email='you@email.address' --accounts='full'",
#    require => Postgresql::Server::Db [ 'beansbooks'],
#  }

  anchor{'beansbooks::config::end':}
}