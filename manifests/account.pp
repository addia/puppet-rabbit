# == Class rabbit::account
# ===========================
#
#
# Description of the Class:
#
#   This class is meant to be called from init.pp only.
#
#
# ===========================
#
class rabbit::account (
  $package_name = $rabbit::params::package_name,
  $user         = $rabbit::params::user,
  $group        = $rabbit::params::group,
  $uid          = $rabbit::params::uid,
  $home_dir     = $rabbit::params::home_dir
) {

  include rabbit::params

  notify { "## --->>> Creating accounts for: ${package_name}": }

  group {  $group:
    ensure => present,
    gid    => $uid
  }

  user { $user:
    ensure     => present,
    home       => $home_dir,
    shell      => '/bin/bash',
    uid        => $uid,
    gid        => $uid,
    password   => '!!',
    managehome => true,
  }

}


# vim: set ts=2 sw=2 et :
