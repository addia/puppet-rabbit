# == Class rabbit::dependencies
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
class rabbit::dependencies (
  $ensure               = $rabbit::params::ensure,
  $version              = $rabbit::params::version,
  $er_version           = $rabbit::params::er_version,
  $patch                = $rabbit::params::patch,
  $package_name         = $rabbit::params::package_name
) inherits rabbit::params {

# notify { "## --->>> Installing dependencies packages for: ${package_name}": }

  package { 'selinux-policy-devel':
     ensure             => $ensure,
     }

# notify { "## --->>> Installing release $er_version patches for Erlang ": }
  package { 'erlang':
     provider           => 'yum',
     ensure             => $er_version,
     install_options    => ['--enablerepo', 'epel-testing'],
     }

  }


# vim: set ts=2 sw=2 et :
