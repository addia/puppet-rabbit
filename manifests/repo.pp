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
class rabbit::repo (
  $erlang_repo   = $rabbit::params::erlang_repo,
  $erlang_gpgkey = $rabbit::params::erlang_gpgkey,
  $rabbit_gpgkey = $rabbit::params::rabbit_gpgkey,
  $package_name  = $rabbit::params::package_name
) {

  include rabbit::params

  notify { "Creating repo for: ${package_name}": }

  case $::osfamily {
    'RedHat': {
      Package { ensure => 'installed' }
      package { $erlang_repo: }
      package { $erlang_gpgkey: }
      package { $rabbit_gpgkey: }
    }

    default: {
      fail("\"${package_name}\" provides no repository information for OSfamily \"${::osfamily}\"")
    }
  }

}


# vim: set ts=2 sw=2 et :
