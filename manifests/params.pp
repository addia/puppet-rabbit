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

  $version                          = '3.6.6'
  $patch                            = '-1'
  $rpm_arch                         = 'el7.noarch'
  $package_name                     = 'rabbitmq-server'
  $rabbit_package                   = "https://www.rabbitmq.com/releases/${package_name}/v${version}/${package_name}-${version}${patch}.${rpm_arch}.rpm"
  $rabbit_gpgkey                    = 'https://www.rabbitmq.com/rabbitmq-release-signing-key.asc'
  $erlang_repo                      = 'https://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm'
  $erlang_gpgkey                    = 'https://packages.erlang-solutions.com/rpm/erlang_solutions.asc'
  $user                             = 'rabbitmq'
  $group                            = 'rabbitmq'
  $uid                              = '250'
  $home_dir                         = '/var/lib/rabbitmq'

  $ssl_server_key                   = 'rabbitmq-server.key'
  $ssl_server_crt                   = 'rabbitmq-server.crt'
  $ssl_client_key                   = 'rabbitmq-client.key'
  $ssl_client_crt                   = 'rabbitmq-client.crt'
  $ssl_cacert_file                  = '/etc/pki/ca-trust/source/anchors/lr_rootca.crt'

  $config_file                      = '/etc/rabbitmq/rabbitmq.config'
  $config_env_file                  = '/etc/rabbitmq/rabbitmq-env.conf'
  $config_adm_file                  = '/etc/rabbitmq/rabbitmqadmin.conf'
  $limits_file                      = '/etc/security/limits.d/30-rabbit.conf'
  $config_cluster                   = true
  $config_admin                     = true
  $configure_origin                 = hiera('rabbitmq_origin_conf',false)
  $admin_help                       = 'rabbit_admin.sh'
  $admin_tool                       = 'rabbitmqadmin'
  $admin_tool_dir                   = '/usr/local/bin'
  $erlang_cookie                    = hiera('rabbitmq_cookie')
  $erlang_cookie_file               = '/var/lib/rabbitmq/.erlang.cookie'
  $cluster_node_type                = 'disc'
  $cluster_data_nic                 = hiera('rabbitmq_data_nic')
  $cluster_name                     = hiera('rabbitmq_clustername')
  $cluster_master                   = hiera('rabbitmq_master')
  $cluster_nodes                    = hiera('rabbitmq_servers')
  $cluster_partition_handling       = 'ignore'
  $default_user                     = 'wabbit'
  $default_pass                     = hiera('rabbitmq_passwd')
  $default_port                     = '5672'
  $default_vhost                    = 'lr-hare'
  $logging_user                     = 'logstash'
  $logging_pass                     = hiera('logstash_passwd')
  $logging_exchange                 = 'logstash'
  $logging_exchange_type            = 'topic'
  $logging_queue                    = 'log-item'
  $logging_key                      = hiera('logstash_key')
  $admin_port                       = '15672'
  $ssl_admin                        = true
  $ssl                              = true
  $ssl_only                         = true
  $ssl_dir                          = '/etc/rabbitmq/ssl'
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
  $file_limit                       = '16384'
  $environment_variables            = {}
  $config_variables                 = {
        'log_levels'                => '[{connection, info}]'
        }
  $config_kernel_variables          = {}
  $config_management_variables      = {}

}
