# == Class: rabbit
# ===========================
#
#
# Description of the Class:
#
#   Install and configure the logstash service pushing messages received from beats into a RabbitMQ Queue
#
#
# Document all Parameters:
#
#   Explanation of what this parameter affects and what it defaults to.
#     ensure                           = package install option
#     version                          = version we want to install
#     patch                            = and the patch to install
#     package_name                     = the package name
#     user                             = run as user
#     group                            = run as group
#     uid                              = default uid/gid
#     home_dir                         = rabbitmq-server home directory
#     repo_gpg_key                     = package gpg signing key
#     service_name                     = name of the service file for the package
#     systemd_file                     = full path and file name of systemd
#     service_file                     = full path and file name of service
#     rabbit_shovel_dest               = rabbitmq address for shovel destination
#     ssl_server_key                   = the rabbitmq-server key file name
#     ssl_server_crt                   = the rabbitmq-server cert file name
#     ssl_client_key                   = the rabbitmq-client key file name
#     ssl_client_crt                   = the rabbitmq-client cert file name
#     config_file                      = the config file
#     config_env_file                  = the environment config file
#     config_adm_file                  = the rabbitmq admin config file
#     limits_file                      = rabbitmq kernel limits
#     tmpfile                          = rabbitmq temp file
#     config_cluster                   = set-up cluster bolean
#     config_admin                     = set-up admin bolean
#     config_shovel                    = set-up shovel bolean
#     config_shovel_name               = the shovel name
#     config_shovel_statics            = shovel stats
#     admin_tool                       = the admin script
#     admin_tool_dir                   = location for the admin script
#     erlang_cookie                    = Erlang cookie value
#     erlang_cookie_file               = file for the cookie
#     cluster_node_type                = type of cluster (mem or disk)
#     cluster_master                   = name of the closter master
#     cluster_nodes                    = names of all nodes
#     cluster_partition_handling       = how to handle partitions
#     default_user                     = rabbit user
#     default_pass                     = rabbit passwd
#     default_port                     = default amqp port
#     default_vhost                    = name of the default vhost
#     logging_user                     = username for logging
#     logging_pass                     = passwd for the logging user
#     logging_exchange                 = rabbit exchange for logging
#     logging_queue                    = rabbit queue for logging
#     logging_key                      = key for accessing the logging queue
#     admin_port                       = default admin port
#     ssl_admin                        = ssl for admin cloean
#     ssl                              = ssl bolean
#     ssl_only                         = ssl bolean
#     ssl_dir                          = ssl directory
#     ssl_cert                         = ssl server ceet
#     ssl_key                          = ssl server key
#     ssl_ccert                        = ssl client cert
#     ssl_ckey                         = ssl client key
#     ssl_port                         = port for ssl
#     ssl_interface                    = ssl interface port
#     ssl_management_port              = ssl management port
#     ssl_stomp_port                   = ssl port for stop
#     ssl_verify                       = ssl verify config
#     ssl_fail_if_no_peer_cert         = ssl fail bolean
#     ssl_versions                     = ssl version
#     ssl_ciphers                      = ssl default cipher
#     file_limit                       = max open file setting
#     environment_variables            = additional env variables
#     config_kernel_variables          = additional kernel variables
#     config_management_variables      = additional admin variables
#
# ===========================
#
#
# == Authors
# ----------
#
# Author: Addi <addi.abel@gmail.com>
#
#
# == Copyright
# ------------
#
# Copyright:  ©  2016  LR / Addi.
#
#
class rabbit (
  $ensure                           = $rabbit::params::ensure,
  $version                          = $rabbit::params::version,
  $patch                            = $rabbit::params::patch,
  $package_name                     = $rabbit::params::package_name,
  $user                             = $rabbit::params::user,
  $group                            = $rabbit::params::group,
  $uid                              = $rabbit::params::uid,
  $home_dir                         = $rabbit::params::home_dir,
  $repo_gpg_key                     = $rabbit::params::repo_gpg_key,
  $service_name                     = $rabbit::params::service_name,
  $systemd_file                     = $rabbit::params::systemd_file,
  $rabbit_shovel_dest               = $rabbit::params::rabbit_shovel_dest,
  $ssl_server_key                   = $rabbit::params::ssl_server_key,
  $ssl_server_crt                   = $rabbit::params::ssl_server_crt,
  $ssl_client_key                   = $rabbit::params::ssl_client_key,
  $ssl_client_crt                   = $rabbit::params::ssl_client_crt,
  $config_file                      = $rabbit::params::config_file,
  $limits_file                      = $rabbit::params::limits_file,
  $service_file                     = $rabbit::params::service_file,
  $tmpfile                          = $rabbit::params::tmpfile,
  $config_env_file                  = $rabbit::params::config_env_file,
  $config_cluster                   = $rabbit::params::config_cluster,
  $config_shovel                    = $rabbit::params::config_shovel,
  $config_shovel_name               = $rabbit::params::config_shovel_name,
  $config_shovel_statics            = $rabbit::params::config_shovel_statics,
  $admin_tool                       = $rabbit::params::admin_tool,
  $admin_tool_dir                   = $rabbit::params::admin_tool_dir,
  $erlang_cookie                    = $rabbit::params::erlang_cookie,
  $erlang_cookie_file               = $rabbit::params::erlang_cookie_file,
  $cluster_node_type                = $rabbit::params::cluster_node_type,
  $cluster_master                   = $rabbit::params::cluster_master,
  $cluster_nodes                    = $rabbit::params::cluster_nodes,
  $cluster_partition_handling       = $rabbit::params::cluster_partition_handling,
  $default_user                     = $rabbit::params::default_user,
  $default_pass                     = $rabbit::params::default_pass,
  $default_vhost                    = $rabbit::params::default_vhost,
  $default_port                     = $rabbit::params::default_port,
  $logging_user                     = $rabbit::params::logging_user,
  $logging_pass                     = $rabbit::params::logging_pass,
  $logging_key                      = $rabbit::params::logging_key,
  $logging_exchange                 = $rabbit::params::logging_exchange,
  $logging_queue                    = $rabbit::params::logging_queue,
  $config_admin                     = $rabbit::params::config_admin,
  $admin_port                       = $rabbit::params::admin_port,
  $ssl_admin                        = $rabbit::params::ssl_admin,
  $ssl                              = $rabbit::params::ssl,
  $ssl_only                         = $rabbit::params::ssl_only,
  $ssl_dir                          = $rabbit::params::ssl_dir,
  $ssl_cert                         = $rabbit::params::ssl_cert,
  $ssl_key                          = $rabbit::params::ssl_key,
  $ssl_ccert                        = $rabbit::params::ssl_ccert,
  $ssl_ckey                         = $rabbit::params::ssl_ckey,
  $ssl_port                         = $rabbit::params::ssl_port,
  $ssl_interface                    = $rabbit::params::ssl_interface,
  $ssl_management_port              = $rabbit::params::ssl_management_port,
  $ssl_verify                       = $rabbit::params::ssl_verify,
  $ssl_fail_if_no_peer_cert         = $rabbit::params::ssl_fail_if_no_peer_cert,
  $ssl_versions                     = $rabbit::params::ssl_versions,
  $ssl_ciphers                      = $rabbit::params::ssl_ciphers,
  $file_limit                       = $rabbit::params::file_limit,
  $environment_variables            = $rabbit::params::environment_variables,
  $config_variables                 = $rabbit::params::config_variables,
  $config_kernel_variables          = $rabbit::params::config_kernel_variables,
  $config_management_variables      = $rabbit::params::config_management_variables

  ) inherits rabbit::params {

    notify { "## --->>> Installing and configuring ${package_name}": }

    anchor { 'rabbit::begin': } ->
    class { '::rabbit::account': } ->
    class { '::rabbit::repo': } ->
    class { '::rabbit::install': } ->
    class { '::rabbit::config': } ->
    class { '::rabbit::service': } ->
    class { '::rabbit::plugins': } ->
    class { '::rabbit::queues': } ->
    anchor { 'rabbit::end': }

}


# vim: set ts=2 sw=2 et :
