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
  $user                             = $rabbit::params::user,
  $group                            = $rabbit::params::group,
  $default_user                     = $rabbit::params::default_user,
  $default_pass                     = $rabbit::params::default_pass,
  $logging_user                     = $rabbit::params::logging_user,
  $logging_pass                     = $rabbit::params::logging_pass,
  $logging_key                      = $rabbit::params::logging_key,
  $default_vhost                    = $rabbit::params::default_vhost,
  $cluster_name                     = $rabbit::params::cluster_name,
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
    creates                         => "/var/lib/rabbitmq/.queues_done",
    path                            => "/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin",
    } ~>

  exec { 'rabbitmq queue' :
    command                         => "rabbit_admin.sh  $queue",
    creates                         => "/var/lib/rabbitmq/.queues_done",
    path                            => "/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin",
    } ~>

  exec { 'rabbitmq binding' :
    command                         => "rabbit_admin.sh  $binding",
    creates                         => "/var/lib/rabbitmq/.queues_done",
    path                            => "/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin",
    } ~>

  # Trap door to only allow queues setup once
  file { "/var/lib/rabbitmq/.queues_done" :
    ensure                          => present,
    content                         => "queues setup completed",
    owner                           => $user,
    group                           => $group,
    mode                            => '0644',
    } ->

  notify { "## --->>> Removing the guest user: ${package_name}":
    } ~>

  exec { 'Removing the guest user' :
    command                         => "/sbin/rabbitmqctl delete_user guest",
    creates                         => "/var/lib/rabbitmq/.deleted_guest",
    path                            => "/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin",
    } ~>

  # Trap door to only allow the delete function to run once
  file { "/var/lib/rabbitmq/.deleted_guest" :
    ensure                          => present,
    content                         => "queues setup completed",
    owner                           => $user,
    group                           => $group,
    mode                            => '0644',
    }

  }


# vim: set ts=2 sw=2 et
