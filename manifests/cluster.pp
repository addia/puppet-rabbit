# == Class rabbit::cluster
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
class rabbit::cluster (
  $ensure                           = $rabbit::params::ensure,
  $user                             = $rabbit::params::user,
  $group                            = $rabbit::params::group,
  $default_vhost                    = $rabbit::params::default_vhost,
  $cluster_name                     = $rabbit::params::cluster_name,
  $package_name                     = $rabbit::params::package_name
  ) inherits rabbit::params {
  

  notify { "## --->>> Configuring the cluster: ${package_name}":
  }

  exec { 'set_the_cluster_name' :
    command                         => "rabbitmqctl set_cluster_name $cluster_name",
    path                            => "/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin",
    creates                         => "/var/lib/rabbitmq/.cluster_name_set",
    unless                          => "rabbit_admin.sh show overview | grep $cluster_name",
  }

  # Trap door to only allow cluster_name setup once
  file { "/var/lib/rabbitmq/.cluster_name_set" :
    ensure                          => present,
    content                         => "cluster_name set completed",
    owner                           => $user,
    group                           => $group,
    mode                            => '0644',
  }

  if $config_cluster {
    rabbitmq_policy { "ha-all@${default_vhost}":
      pattern                       => '.*',
      priority                      => 0,
      applyto                       => 'all',
      definition => {
        'ha-mode'                   => 'all',
        'ha-sync-mode'              => 'automatic',
      }
    }
  }

}


# vim: set ts=2 sw=2 et
