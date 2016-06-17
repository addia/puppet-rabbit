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
  $user               = $rabbit::params::user,
  $group              = $rabbit::params::group,
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

  exec { 'fixing the plug-in owner' :
    command           => "chown -R $user:$group /var/lib/rabbitmq",
    path              => "/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin/:/bin/:/sbin/",
  } ~>

  notify { "## --->>> Loading the plug-ins: ${package_name}":
  } ~>

  exec { 'Loading the plug-ins' :
    command           => "systemctl restart ${package_name}",
    creates           => "/var/lib/rabbitmq/.plugins_done",
    path              => "/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin/:/bin/:/sbin/",
  } ~>

  # Trap door to only allow plugin setup once
  file { "/var/lib/rabbitmq/.plugins_done" :
    ensure            => present,
    content           => "plugin setup completed",
    owner             => $user,
    group             => $group,
    mode              => '0644',
  }

  file { "${admin_tool_dir}/${admin_tool}":
    ensure            => present,
    owner             => 'root',
    group             => 'root',
    mode              => '0755',
    # source          => "puppet:///modules/rabbit/${admin_tool}-${version}${patch}",
    source            => "puppet:///modules/rabbit/${admin_tool}",
  }

}


# vim: set ts=2 sw=2 et :
