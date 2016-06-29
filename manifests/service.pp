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
  $package_name                     = $rabbit::params::package_name
) inherits rabbit::params {
  
  notify { "## --->>> Configuring service for: ${package_name}": } ~>

  exec { 'register new systemd script':
    command                         => "systemctl daemon-reload",
    creates                         => "/var/lib/rabbitmq/.service_done",
    path                            => "/sbin:/bin:/usr/sbin:/usr/bin",
    } ~>

  service { $package_name:
    ensure                          => running,
    enable                          => true,
    hasrestart                      => true,
    hasstatus                       => true,
    } ~>

  # Trap door to only allow service setup once
  file { "/var/lib/rabbitmq/.service_done" :
    ensure                          => present,
    content                         => "service setup completed",
    owner                           => $user,
    group                           => $group,
    mode                            => '0644',
    }

  }


# vim: set ts=2 sw=2 et :
