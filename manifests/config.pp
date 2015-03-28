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

  ## configure apache
  apache::vhost { 'beansbooks':
    servername  => 'beansbooks',
    port        => '80',
    docroot     => $beansbooks::dest_path,
    directories => [ 
      {
        path => $beansbooks::dest_path,
        auth_require => 'all granted',
        allow_override => ['All'],
        options => ['FollowSymLinks'],
      }
    ],
    require     => Anchor['beansbooks::config::begin'],
  }

  ## configure postgresql
  postgresql::server::db { 'beansbooks':
    user     => $beansbooks::db_user,
    password => postgresql_password($beansbooks::db_user, $beansbooks::db_pass),
    ## utf8 ??
    require  => Apache::Vhost['beansbooks'],
  }

#  exec {'web install':
#    command => "php index.php --uri=/install/manual --name='Your Name' --password='password' --email='you@email.address' --accounts='full'",
#    require => Postgresql::Server::Db [ 'beansbooks'],
#  }

  anchor{'beansbooks::config::end':}
}