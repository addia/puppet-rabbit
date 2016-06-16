# == Class rabbit::queues
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
class rabbit::queues (
  $ensure                           = $rabbit::params::ensure,
  $default_user                     = $rabbit::params::default_user,
  $default_pass                     = $rabbit::params::default_pass,
  $logging_user                     = $rabbit::params::logging_user,
  $logging_pass                     = $rabbit::params::logging_pass,
  $logging_key                      = $rabbit::params::logging_key,
  $default_vhost                    = $rabbit::params::default_vhost,
  $logging_exchange                 = $rabbit::params::logging_exchange,
  $logging_queue                    = $rabbit::params::logging_queue,
  $package_name                     = $rabbit::params::package_name
  ) inherits rabbit::params {
  
  $exchange                         = "declare exchange name=$logging_exchange type=topic"
  $queue                            = "declare queue name=$logging_queue durable=true auto_delete=false"
  $binding                          = "declare binding source=$logging_exchange destination=$logging_queue routing_key=$logging_key destination_type=queue"

  notify { "## --->>> Configuring users and queues: ${package_name}":
  } ~>

  rabbitmq_user { $default_user:
    admin                           => true,
    password                        => $default_pass,
  } ~>

  rabbitmq_user { $logging_user:
    admin                           => false,
    password                        => $logging_pass,
    tags                            => 'logging',
  } ~>

  rabbitmq_vhost { $default_vhost:
    ensure                          => $ensure,
  } ~>

  rabbitmq_user_permissions { "${default_user}@${default_vhost}":
    configure_permission            => '.*',
    read_permission                 => '.*',
    write_permission                => '.*',
  } ~>

  rabbitmq_user_permissions { "${logging_user}@${default_vhost}":
    configure_permission            => '.*',
    read_permission                 => '.*',
    write_permission                => '.*',
  } ~>

  exec { 'rabbitmq exchange' :
    command                         => "rabbit_admin.sh  $exchange",
    path                            => "/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin/:/bin/:/sbin/",
  } ~>

  exec { 'rabbitmq queue' :
    command                         => "rabbit_admin.sh  $queue",
    path                            => "/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin/:/bin/:/sbin/",
  } ~>

  exec { 'rabbitmq binding' :
    command                         => "rabbit_admin.sh  $binding",
    path                            => "/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin/:/bin/:/sbin/",
  } ~>

  notify { "## --->>> Removing the guest user: ${package_name}":
  } ~>

  exec { 'Finally, delete the build-in user' :
    command => "/sbin/rabbitmqctl delete_user guest",
      onlyif  =>  [ '/sbin/rabbitmqctl list_users | grep -c guest' ],
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
