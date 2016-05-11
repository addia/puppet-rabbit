# == Class rabbit::repo
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
class rabbit::repo {
  $package_name       = $rabbit::params::package_name,
  ) inherits rabbit::params {

  notify { "## --->>> Configure the repo for: ${package_name}": }

  case $::osfamily {
    'RedHat': {
      package { 'epel-release':
        ensure        => 'present',
      }
    }
  }

}


# vim: set ts=2 sw=2 et :
