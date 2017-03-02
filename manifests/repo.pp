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
  $package_name  = $rabbit::params::package_name
) {

  include rabbit::params

  notify { "Creating repo for: ${package_name}": }


  # this installs the shiny new Erlang repo:
  case $::osfamily {
    'RedHat': {
      exec { 'Import Erlang key':
        command  => "rpm --import ${erlang_gpgkey}"
      }
      package { $erlang_repo:
        ensure => 'installed'
      }
    }

    default: {
      fail("\"${package_name}\" provides no repository information for OSfamily \"${::osfamily}\"")
    }
  }

}


# vim: set ts=2 sw=2 et :
