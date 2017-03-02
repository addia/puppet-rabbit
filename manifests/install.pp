# == Class rabbit::install
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
class rabbit::install (
  $ensure              = $rabbit::params::ensure,
  $rabbit_package      = $rabbit::params::rabbit_package,
  $ssl_management_port = $rabbit::params::ssl_management_port,
  $package_name        = $rabbit::params::package_name
) {

  include rabbit::params

  notify { "## --->>> Installing package: ${package_name}": }

  Package { ensure => 'installed' }
  $depends = ['socat', 'erlang']
  package { $depends: }
  package { 'rabbit_server':
    source   => $rabbit_package,
    provider => 'rpm',
  }

  selinux::module { 'rabbitmq':
    ensure => 'present',
    source => 'puppet:///modules/rabbit/rabbitmq.te'
  }

  selinux::port { 'allow_rabbitadmin_port':
    context  => 'rabbitmq_port_t',
    port     => $ssl_management_port,
    protocol => 'tcp',
  }

}


# vim: set ts=2 sw=2 et :
