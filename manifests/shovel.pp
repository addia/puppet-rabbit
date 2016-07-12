# == Class rabbit::shovel
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
class rabbit::shovel (
  $user                             = $rabbit::params::user,
  $group                            = $rabbit::params::group,
  $ssl_server_key                   = $rabbit::params::ssl_server_key,
  $ssl_server_crt                   = $rabbit::params::ssl_server_crt,
  $ssl_server_pem                   = $rabbit::params::ssl_server_pem,
  $ssl_client_key                   = $rabbit::params::ssl_client_key,
  $ssl_client_crt                   = $rabbit::params::ssl_client_crt,
  $ssl_client_pem                   = $rabbit::params::ssl_client_pem,
  $ssl_shovel_key                   = $rabbit::params::ssl_shovel_key,
  $ssl_shovel_crt                   = $rabbit::params::ssl_shovel_crt,
  $ssl_cacert_file                  = $rabbit::params::ssl_cacert_file,
  $ssl_port                         = $rabbit::params::ssl_port,
  $ssl_dir                          = $rabbit::params::ssl_dir,
  $ssl_cert                         = $rabbit::params::ssl_cert,
  $ssl_key                          = $rabbit::params::ssl_key,
  $ssl_pem                          = $rabbit::params::ssl_pem,
  $ssl_ccert                        = $rabbit::params::ssl_ccert,
  $ssl_ckey                         = $rabbit::params::ssl_ckey,
  $ssl_cpem                         = $rabbit::params::ssl_cpem,
  $ssl_scert                        = $rabbit::params::ssl_scert,
  $ssl_skey                         = $rabbit::params::ssl_skey,
  $ssl_verify                       = $rabbit::params::ssl_verify,
  $ssl_fail_if_no_peer_cert         = $rabbit::params::ssl_fail_if_no_peer_cert,
  $ssl_management_port              = $rabbit::params::ssl_management_port,
  $erlang_cookie                    = $rabbit::params::erlang_cookie,
  $erlang_cookie_file               = $rabbit::params::erlang_cookie_file,
  $default_port                     = $rabbit::params::default_port,
  $config_shovel                    = $rabbit::params::config_shovel,
  $config_shovel_name               = $rabbit::params::config_shovel_name,
  $config_shovel_passwd             = $rabbit::params::config_shovel_passwd,
  $config_shovel_statics            = $rabbit::params::config_shovel_statics,
  $shovel_origin                    = $rabbit::params::shovel_origin,
  $logging_user                     = $rabbit::params::logging_user,
  $logging_pass                     = $rabbit::params::logging_pass,
  $logging_key                      = $rabbit::params::logging_key,
  $logging_exchange                 = $rabbit::params::logging_exchange,
  $logging_exchange_type            = $rabbit::params::logging_exchange_type,
  $logging_queue                    = $rabbit::params::logging_queue,
  $config_admin                     = $rabbit::params::config_admin,
  $admin_help                       = $rabbit::params::admin_help,
  $admin_tool_dir                   = $rabbit::params::admin_tool_dir,
  $admin_port                       = $rabbit::params::admin_port,
  $config_file                      = $rabbit::params::config_file,
  $limits_file                      = $rabbit::params::limits_file,
  $service_file                     = $rabbit::params::service_file,
  $tmpfile                          = $rabbit::params::tmpfile,
  $file_limit                       = $rabbit::params::file_limit,
  $config_cluster                   = $rabbit::params::config_cluster,
  $cluster_node_type                = $rabbit::params::cluster_node_type,
  $cluster_data_nic                 = $rabbit::params::cluster_data_nic,
  $cluster_master                   = $rabbit::params::cluster_master,
  $cluster_nodes                    = $rabbit::params::cluster_nodes,
  $cluster_partition_handling       = $rabbit::params::cluster_partition_handling,
  $config_env_file                  = $rabbit::params::config_env_file,
  $config_adm_file                  = $rabbit::params::config_adm_file,
  $package_name                     = $rabbit::params::package_name,
  $environment_variables            = $rabbit::params::environment_variables,
  $config_variables                 = $rabbit::params::config_variables,
  $config_kernel_variables          = $rabbit::params::config_kernel_variables,
  $config_management_variables      = $rabbit::params::config_management_variables
) inherits rabbit::params {

  notify { "## --->>> Creating the shovel config for: ${package_name}": }


    if $config_shovel {


      if $rabbit_hostname == $cluster_master {
        $rabbitmq_master                = true
        }
      else {
        $rabbitmq_master                = false
        }

      file { $config_file: 
        ensure                          => file,
        replace                         => false,
        owner                           => $user,
        group                           => $group,
        mode                            => '0644',
        content                         => template('rabbit/rabbitmq_config.erb'),
        notify                          => Service[$package_name],
        }

      }
   }


# via: set ts=2 sw=2 et :
