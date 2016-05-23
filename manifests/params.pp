# == Class rabbit::params
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
class rabbit::params {

  $ensure                           = 'present'
  $version                          = '3.5.7'
  $patch                            = '-1'
  $package_name                     = 'rabbitmq-server'
  $user                             = 'rabbitmq'
  $group                            = 'rabbitmq'
  $uid                              = '250'
  $home_dir                         = '/var/lib/rabbitmq'
  $repo_gpg_key                     = 'http://www.rabbitmq.com/rabbitmq-signing-key-public.asc'
  $service_name                     = "${package_name}.service"
  $systemd_file                     = "/usr/lib/systemd/system/${service_name}"
  $service_file                     = "/usr/lib/systemd/system/${service_name}"

  $rabbit_shovel_dest               = hiera('elk_stack_rabbitmq_address')
  $ssl_server_key                   = "rabbitmq-server.key"
  $ssl_server_crt                   = "rabbitmq-server.crt"
  $ssl_client_key                   = "rabbitmq-client.key"
  $ssl_client_crt                   = "rabbitmq-client.crt"

  $config_file                      = '/etc/rabbitmq/rabbitmq.config'
  $config_env_file                  = '/etc/rabbitmq/rabbitmq-env.conf'
  $config_adm_file                  = '/etc/rabbitmq/rabbitmqadmin.conf'
  $limits_file                      = '/etc/security/limits.d/30-rabbit.conf'
  $tmpfile                          = '/usr/lib/tmpfiles.d/rabbitmq.conf'
  $config_cluster                   = false
  $config_admin                     = true
  $config_shovel                    = false
  $config_shovel_name               = "bunny_shovel"
  $config_shovel_statics            = {}
  $admin_tool                       = 'rabbitmqadmin'
  $admin_tool_dir                   = '/usr/local/bin'
  $erlang_cookie                    = hiera('elk_stack_rabbitmq_cookie')
  $erlang_cookie_file               = "/var/lib/rabbitmq/.erlang.cookie"
  $cluster_node_type                = 'disc'
  $cluster_data_nic                 = hiera('elk_stack_rabbitmq_data_nic')
  $cluster_master                   = hiera('elk_stack_rabbitmq_master')
  $cluster_nodes                    = hiera('elk_stack_rabbitmq_servers')
  $cluster_partition_handling       = 'ignore'
  $default_user                     = 'wabbit'
  $default_pass                     = hiera('elk_stack_rabbitmq_passwd')
  $default_port                     = '5672'
  $default_vhost                    = 'lr-hare'
  $logging_user                     = 'logstash'
  $logging_pass                     = hiera('elk_stack_logstash_passwd')
  $logging_exchange                 = 'logstash'
  $logging_queue                    = 'log-item'
  $logging_key                      = hiera('elk_stack_logstash_key')
  $admin_port                       = '15672'
  $ssl_admin                        = true
  $ssl                              = true
  $ssl_only                         = true
  $ssl_dir                          = "/etc/rabbitmq/ssl"
  $ssl_cert                         = "${ssl_dir}/${ssl_server_crt}"
  $ssl_key                          = "${ssl_dir}/${ssl_server_key}"
  $ssl_ccert                        = "${ssl_dir}/${ssl_client_crt}"
  $ssl_ckey                         = "${ssl_dir}/${ssl_client_key}"
  $ssl_port                         = '5671'
  $ssl_interface                    = 'UNSET'
  $ssl_management_port              = '15671'
  $ssl_stomp_port                   = '6164'
  $ssl_verify                       = 'verify_none'
  $ssl_fail_if_no_peer_cert         = false
  $ssl_versions                     = undef
  $ssl_ciphers                      = []
  $file_limit                       = "16384"
  $environment_variables            = {}
  $config_variables                 = {
        'log_levels'                => "[{connection, info}]"
        }
  $config_kernel_variables          = {}
  $config_management_variables      = {}

}
