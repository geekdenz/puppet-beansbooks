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
    require       => Anchor['beansbooks::config::begin'],
  }

  class {'check_run':
    require => Postgresql::Server::Db['beansbooks'],
  }

  check_run::task {'web_install':
    exec_command => "/usr/bin/php index.php --uri=/install/manual\
 --name='${beansbooks::admin_user_full_name}'\
 --password='${beansbooks::admin_user_pass}'\
 --email='${beansbooks::admin_user_email}'\
 --accounts='full'",
    require => Class['check_run'],
  }

  anchor{'beansbooks::config::end':
    require => Check_run::Task['web_install'],
  }
}