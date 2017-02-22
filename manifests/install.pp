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
  $rabbit_erlang       = $rabbit::params::rabbit_erlang,
  $ssl_management_port = $rabbit::params::ssl_management_port,
  $package_name        = $rabbit::params::package_name
) {

  include rabbit::params

# notify { "## --->>> Installing package: ${package_name}": }

  Package { ensure => 'installed' }
  $depends = ['selinux-policy-devel','socat']
  package { $depends: }
  package { $rabbit_erlang: }
  package { $rabbit_package: }

  selinux::module { 'rabbitmq':
    ensure => 'present',
    source => 'puppet:///modules/rabbit/rabbitmq.te'
  }

  selinux::port { 'allow_rabbitadmin_port':
    context  => 'rabbitmq_port_t',
    port     => $ssl_management_port,
    protocol => 'tcp',
  }

# notify { "## --->>> removing old sysvinit file instlled by: ${package_name}": }

  exec { 'stop old init script':
    command => "systemctl disable ${package_name}",
    path    => '/sbin:/bin:/usr/sbin:/usr/bin',
    onlyif  => "test -x /etc/rc.d/init.d/${package_name}",
  }

  exec { 'remove old init file':
    command => "rm -f /etc/rc.d/init.d/${package_name}",
    path    => '/sbin:/bin:/usr/sbin:/usr/bin',
    onlyif  => "test -x /etc/rc.d/init.d/${package_name}",
  }

}


# vim: set ts=2 sw=2 et :
