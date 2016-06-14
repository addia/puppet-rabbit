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
  $patch                = $rabbit::params::patch,
  $package_name         = $rabbit::params::package_name
) inherits rabbit::params {

  notify { "## --->>> Installing default packages for: ${package_name}": }

  $rabbits = ['java-1.8.0-openjdk', 'java-1.8.0-openjdk-devel' ,'selinux-policy-devel']
  package { $rabbits:
     ensure             => $ensure,
     }

  notify { "## --->>> Installing release 'R16B-03.17' patches for Erlang ": }
  package { 'erlang':
     provider           => 'yum',
     ensure             => 'R16B-03.17.el7',
     install_options    => ['--enablerepo', 'epel-testing'],
     }

  }


# vim: set ts=2 sw=2 et :
