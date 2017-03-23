# == Class rabbit::config
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
class rabbit::config (
  $user                        = $rabbit::params::user,
  $group                       = $rabbit::params::group,
  $default_user                = $rabbit::params::default_user,
  $default_pass                = $rabbit::params::default_pass,
  $default_vhost               = $rabbit::params::default_vhost,
  $ssl_server_key              = $rabbit::params::ssl_server_key,
  $ssl_server_crt              = $rabbit::params::ssl_server_crt,
  $ssl_client_key              = $rabbit::params::ssl_client_key,
  $ssl_client_crt              = $rabbit::params::ssl_client_crt,
  $ssl_cacert_file             = $rabbit::params::ssl_cacert_file,
  $ssl_port                    = $rabbit::params::ssl_port,
  $ssl_dir                     = $rabbit::params::ssl_dir,
  $ssl_cert                    = $rabbit::params::ssl_cert,
  $ssl_key                     = $rabbit::params::ssl_key,
  $ssl_ccert                   = $rabbit::params::ssl_ccert,
  $ssl_ckey                    = $rabbit::params::ssl_ckey,
  $ssl_verify                  = $rabbit::params::ssl_verify,
  $ssl_fail_if_no_peer_cert    = $rabbit::params::ssl_fail_if_no_peer_cert,
  $ssl_management_port         = $rabbit::params::ssl_management_port,
  $erlang_cookie               = $rabbit::params::erlang_cookie,
  $erlang_cookie_file          = $rabbit::params::erlang_cookie_file,
  $default_port                = $rabbit::params::default_port,
  $logging_user                = $rabbit::params::logging_user,
  $logging_pass                = $rabbit::params::logging_pass,
  $logging_key                 = $rabbit::params::logging_key,
  $logging_exchange            = $rabbit::params::logging_exchange,
  $logging_exchange_type       = $rabbit::params::logging_exchange_type,
  $logging_queue               = $rabbit::params::logging_queue,
  $config_admin                = $rabbit::params::config_admin,
  $config_cluster              = $rabbit::params::config_cluster,
  $configure_origin            = $rabbit::params::configure_origin,
  $admin_help                  = $rabbit::params::admin_help,
  $admin_tool_dir              = $rabbit::params::admin_tool_dir,
  $admin_port                  = $rabbit::params::admin_port,
  $config_file                 = $rabbit::params::config_file,
  $limits_file                 = $rabbit::params::limits_file,
  $file_limit                  = $rabbit::params::file_limit,
  $cluster_node_type           = $rabbit::params::cluster_node_type,
  $cluster_data_nic            = $rabbit::params::cluster_data_nic,
  $rabbit_address              = $rabbit::params::rabbit_address,
  $cluster_master              = $rabbit::params::cluster_master,
  $cluster_nodes               = $rabbit::params::cluster_nodes,
  $cluster_partition_handling  = $rabbit::params::cluster_partition_handling,
  $config_env_file             = $rabbit::params::config_env_file,
  $config_adm_file             = $rabbit::params::config_adm_file,
  $package_name                = $rabbit::params::package_name,
  $environment_variables       = $rabbit::params::environment_variables,
  $config_variables            = $rabbit::params::config_variables,
  $config_kernel_variables     = $rabbit::params::config_kernel_variables,
  $config_management_variables = $rabbit::params::config_management_variables
) {

  include rabbit::params

  notify { "## --->>> fixing and configuring the hosts names: ${package_name}": }

  $rabbit_hostname     = $::hostname
  $rabbit_domain       = $::domain
  if $cluster_data_nic == 'eth0' {
    $rabbit_ip         = $::ipaddress_eth0
  }
  if $cluster_data_nic == 'eth1' {
    $rabbit_ip         = $::ipaddress_eth1
  }

  exec { 'fix_the_hostname_pants':
    command => 'cat /etc/hosts | tr [:upper:] [:lower:] > /tmp/hh; mv -f /tmp/hh /etc/hosts',
    onlyif  => "grep -v '^#' /etc/hosts | grep -q -e '[[:upper:]]'",
    path    => '/sbin:/bin:/usr/sbin:/usr/bin',
  }

  host { "${rabbit_hostname}.${rabbit_domain}":
    ensure       => 'present',
    target       => '/etc/hosts',
    ip           => $rabbit_ip,
    host_aliases => [$rabbit_hostname, 'rabbit']
  }

  notify { "## --->>> Preparing the origin config variables for: ${package_name}": }

  notify { "## --->>> value of facter: ${::rabbitmq_plugins_done}  and  config  ${configure_origin}  ":}
  if $::rabbitmq_plugins_done == 0 {
    if $configure_origin == true {
        include logreceiver
    }
  }


  notify { "## --->>> Creating config files for: ${package_name}": }

  file { $config_env_file:
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('rabbit/rabbitmq_env_config.erb'),
  }

  file { "${admin_tool_dir}/${admin_help}":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('rabbit/rabbit_admin_sh.erb'),
  }

  file { $config_adm_file:
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('rabbit/rabbitmqadmin_conf.erb'),
  }

  file { $config_file:
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('rabbit/rabbitmq_config.erb'),
  }

  file { $limits_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('rabbit/30-rabbit_conf.erb'),
  }

  file { $erlang_cookie_file:
    ensure  => file,
    replace => false,
    owner   => $user,
    group   => $group,
    mode    => '0600',
    content => template('rabbit/erlang_cookie.erb'),
  }

  file { '/run/rabbitmq':
    ensure => 'directory',
    owner  => $user,
    group  => $group,
    mode   => '0750',
  }

  file { $ssl_dir:
    ensure => 'directory',
    owner  => $user,
    group  => $group,
    mode   => '0750',
  }

  file { $ssl_key:
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => hiera('rabbitmq_server_key')
  }

  file { $ssl_cert:
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => hiera('rabbitmq_server_cert')
  }

  file { $ssl_ckey:
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => hiera('rabbitmq_client_key')
  }

  file { $ssl_ccert:
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => hiera('rabbitmq_client_cert')
  }

  file { $ssl_cacert_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => hiera('root_ca_cert')
  }

  exec { 'Loading the cacert' :
    command => "update-ca-trust",
    creates => '/var/lib/rabbitmq/.caroot_done',
    path    => '/sbin:/bin:/usr/sbin:/usr/bin:/bin/:/sbin/',
  }

  exec { 'Loading the configs' :
    command => "systemctl enable ${package_name}; systemctl start ${package_name}",
    creates => '/var/lib/rabbitmq/.configs_done',
    path    => '/sbin:/bin:/usr/sbin:/usr/bin:/bin/:/sbin/',
  } ~>

  # Trap door to only allow configs setup once
  file { '/var/lib/rabbitmq/.configs_done' :
    ensure  => present,
    content => 'configs setup completed',
    owner   => $user,
    group   => $group,
    mode    => '0644',
  }

}


# vim: set ts=2 sw=2 et :
