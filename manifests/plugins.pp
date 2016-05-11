# == Class rabbit::plugins
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
class rabbit::plugins (
  $ensure             = $rabbit::params::ensure,
  $admin_tool         = $rabbit::params::admin_tool,
  $admin_tool_dir     = $rabbit::params::admin_tool_dir,
  $version            = $rabbit::params::version,
  $patch              = $rabbit::params::patch,
  $package_name       = $rabbit::params::package_name
  ) inherits rabbit::params {

  $plugins = ['rabbitmq_shovel_management','rabbitmq_shovel','rabbitmq_amqp1_0','rabbitmq_management_visualiser','rabbitmq_management']

  notify { "## --->>> Installing plugins for package: ${package_name}":
  } ~>

  rabbitmq_plugin { $plugins:
    ensure            => $ensure,
  } ~>

  notify { "## --->>> Loading the plug-ins: ${package_name}":
  } ~>

  exec { 'Loading the plug-ins' :
    command           => "service $package_name restart",
    path              => '/usr/local/bin/:/bin/:/sbin/',
  }

  file { $admin_tool_dir/$admin_tool:
    ensure            => present,
    owner             => 'root',
    group             => 'root',
    mode              => '0755',
    source            => "puppet:///modules/rabbit/${admin_tool}-${version}-${patch}"
  }

}


# vim: set ts=2 sw=2 et :
