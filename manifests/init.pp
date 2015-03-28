# == Class: beansbooks
#
# Installs and configures the beansbooks web site.
#
# === Parameters
#
# [*admin_user_full_name*]
#   The full name of the admin or owner of the site.
#
# [*admin_user_email*]
#   The admin's email address.
#
# [*admin_user_pass*]
#   The password of the admin user (to login to the web site.
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
class beansbooks (
	$sha_hash,
	$sha_salt,
	$cookie_salt, 
  $key,	 
  $admin_user_full_name,
  $admin_user_email,
  $admin_user_pass,
  $servername = 'localhost',
  $db_host = 'localhost',
  $db_user = 'beans',
  $db_pass = 'beans',
){
  
  ## variables
  $src_path = '/opt/beansbooks'
  $dest_path = '/var/www/beansbooks'
  anchor {'beansbooks::begin':}
  
  class {'beansbooks::install':
    require => Anchor ['beansbooks::begin']
  }
  class {'beansbooks::config':
    require => Class['beansbooks::install']
  }

  anchor {'beansbooks::end':}

}