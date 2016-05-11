# == Class rabbit::service
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
class rabbit::service (
  $package_name         = $rabbit::params::package_name
  ) inherits rabbit::params {
  
  notify { "## --->>> Configuring service for: ${package_name}": } ~>

  exec { 'register new systemd script':
    command             => "systemctl daemon-reload",
    path                => "/sbin:/bin:/usr/sbin:/usr/bin",
  } ~>

  service { $package_name:
    ensure              => running,
    enable              => true,
    hasrestart          => true,
    hasstatus           => true,
  }

}


# vim: set ts=2 sw=2 et :
