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
  $ensure                  = $rabbit::params::ensure,
  $version                 = $rabbit::params::version,
  $patch                   = $rabbit::params::patch,
  $ssl_management_port     = $rabbit::params::ssl_management_port,
  $package_name            = $rabbit::params::package_name
) inherits rabbit::params {

# notify { "## --->>> Installing package: ${package_name}-${version}${patch}": }

  package { "${package_name}-${version}${patch}" :
    ensure                 => 'installed',
    provider               => 'rpm',
    source                 => "https://www.rabbitmq.com/releases/${package_name}/v${version}/${package_name}-${version}${patch}.noarch.rpm",
  }

  selinux::module { 'rabbitmq':
    ensure                 => 'present',
    source                 => 'puppet:///modules/rabbit/rabbitmq.te'
  }

  selinux::port { 'allow_rabbitadmin_port':
    context                => 'rabbitmq_port_t',
    port                   => $ssl_management_port,
    protocol               => 'tcp',
    }

# notify { "## --->>> removing old sysvinit file instlled by: ${package_name}": }

  exec { 'stop old init script':
    command                => "systemctl disable ${package_name}",
    path                   => "/sbin:/bin:/usr/sbin:/usr/bin",
    onlyif                 => "test -x /etc/rc.d/init.d/${package_name}",
  }

  exec { 'remove old init file':
    command                => "rm -f /etc/rc.d/init.d/${package_name}",
    path                   => "/sbin:/bin:/usr/sbin:/usr/bin",
    onlyif                 => "test -x /etc/rc.d/init.d/${package_name}",
  }

}


# vim: set ts=2 sw=2 et :
