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
  $ensure               = $rabbit::params::ensure,
  $version              = $rabbit::params::version,
  $patch                = $rabbit::params::patch,
  $package_name         = $rabbit::params::package_name

  ) inherits rabbit::params {

  notify { "## --->>> Installing default packages for: ${package_name}": }

  $rabbits = ['erlang', 'java-1.8.0-openjdk', 'java-1.8.0-openjdk-devel' ,'selinux-policy-devel']
  package { $rabbits:
     ensure             => $ensure,
     } ~>

  notify { "## --->>> Installing package: ${package_name}-${version}${patch}": } ~>

  package { "${package_name}-${version}${patch}" :
    ensure              => 'installed',
    provider            => 'rpm',
    source              => "https://www.rabbitmq.com/releases/${package_name}/v${version}/${package_name}-${version}${patch}.noarch.rpm",
  } ~>

  selinux::module { 'rabbitmq':
    ensure              => 'present',
    prefix              => 'se_',
    sx_mod_dir          => '/usr/share/selinux',
    source              => 'puppet:///modules/rabbit/rabbitmq_local.te'
  } ~>

  notify { "## --->>> removing old sysvinit file instlled by: ${package_name}": } ~>

  exec { 'stop old init script':
    command             => "systemctl disable ${package_name}",
    path                => "/sbin:/bin:/usr/sbin:/usr/bin",
    onlyif              => "test -x /etc/rc.d/init.d/${package_name}",
  } ~>

  exec { 'unregister old init script':
    command             => "systemctl daemon-reload",
    path                => "/sbin:/bin:/usr/sbin:/usr/bin",
  } ~>

  exec { 'remove old init file':
    command             => "rm -f /etc/rc.d/init.d/${package_name}",
    path                => "/sbin:/bin:/usr/sbin:/usr/bin",
    onlyif              => "test -x /etc/rc.d/init.d/${package_name}",
  }

}


# vim: set ts=2 sw=2 et :
