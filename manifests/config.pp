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
  postgresql::server::db { 'beans':
    user     => $beansbooks::db_user,
    password => postgresql_password($beansbooks::db_user, $beansbooks::db_pass),
    ## utf8 ??
    require       => Anchor['beansbooks::config::begin'],
  }
  
  file { "${beansbooks::dest_path}/application/classes/beans/config.php":
    ensure  => file,
    mode    => '0660',
    owner   => 'www-data',
    content => template('beansbooks/config.php.erb'),
    require => Postgresql::Server::Db['beans'],
  }

  file { "${beansbooks::dest_path}/application/logs":
    mode => '0666',
    require => File [
      "${beansbooks::dest_path}/application/classes/beans/config.php"
    ],
  }

  file { "${beansbooks::dest_path}/application/cache":
    mode => '0666',
    require => File [
      "${beansbooks::dest_path}/application/logs"
    ],
  }

  check_run::task {'web_install':
    exec_command => "/usr/bin/php index.php --uri=/install/manual\
 --name='${beansbooks::admin_user_full_name}'\
 --password='${beansbooks::admin_user_pass}'\
 --email='${beansbooks::admin_user_email}'\
 --accounts='full'",
    cwd         => $beansbooks::dest_path,
    require => File [
      "${beansbooks::dest_path}/application/cache"
    ],
  }

  anchor{'beansbooks::config::end':
    require => Check_run::Task['web_install'],
  }
}
