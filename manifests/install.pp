# == Class: beansbooks::install
#
# Installs the required packages.
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
class beansbooks::install {
  
  anchor {'beansbooks::install::begin':}
  
  ## packages
  $packages = ['php5-cli','php5-mcrypt','php5-gd','php5-pgsql']
  package{$packages:
    ensure  => installed,
    require => Anchor ['beansbooks::install::begin'],
  }
  
  ## apache
  class {'apache':
    mpm_module => 'prefork',
    default_vhost => false,
    servername    => $beansbooks::servername,
    require       => Package[$packages],
  }
  class {'::apache::mod::php':}
  class {'::apache::mod::rewrite':}
  

  ## postgresql
  class { 'postgresql::server': 
    require => Class['apache','::apache::mod::php','::apache::mod::rewrite']
  }

  ## source code
  vcsrepo { $beansbooks::src_path:
    ensure   => present,
    provider => 'git',
    source   => 'https://github.com/system76/beansbooks.git',
    require  => Class['postgresql::server'],
  }
  
  ## copy the source  
  exec {'copy src':
    command => "/bin/cp -r ${beansbooks::src_path} ${beansbooks::dest_path}",
    creates => $beansbooks::dest_path,
    require => Vcsrepo [ $beansbooks::src_path ],
  }

  anchor {'beansbooks::install::end':
    require => Vcsrepo [$beansbooks::src_path]
  }
}