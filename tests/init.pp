# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
include lrrabbitmq
include account

# my account for testing 
class account {
  group { 'sysadm':
    ensure       => present,
    gid          => 500,
  }
  user { 'addi':
    # use: openssl passwd -1
    ensure       => 'present',
    comment      => 'Addi,,,',
    gid          => '500',
    groups       => ['wheel', 'users'],
    password     => '$1$O.El..oJ$XQgfZuciHGNoQmaC4Ej36.',
    managehome   => true,
    home         => '/home/addi',
    shell        => '/bin/bash',
    uid          => '500',
  }
  ssh_authorized_key { 'addi.abel@digital.landregistry.gov.uk':
    user       => 'addi',
    type       => 'rsa',
    key        => "AAAAB3NzaC1yc2EAAAADAQABAAACAQDlMXhKDE034CYh/0KHL3MA7gJyMnV+2UDh2+GORb/hOJXFuxcm93T07zMnXiKm3FVnej/fJu4k0kiLlNYyw2PAxD2tSCZYC9XYaUmgDJV46zNn//0BXOmCfHtXGgbNPQDKNgHArbKQ/v9l0lWJwWCwS356o0lQp+a4+DzvlOp1kBGxuc2Ga+FoHGrBYWlqv1ahBgfMgOQovEaKRRu15ZVjLY+sz4vRjaOJ+uWwsIchsdFCGl0q4jFa1ekwhdlaUfFK9IZx6aBNO/8/BX8nxfvSvYkSyILl984ZSIu8/twFtPTGnfFVRUKQKTthlM5PomUSQefA/p/LJ4H7TMNlq7uQQ1UQjpnk5N2XAOpBUI6gwDAZg+aWPLDujaOwSgqv9A+SXCclm9zvVjgoSffA/2zGxIAwweDaBbiZa6OloNg7E00W8r+VtL8t35IDyvAXDXi9/YoUxQkwyGsvOv4V9iAjCJa3VBLwlE0VuvadQqPU0cv4fzqS3vJy1S6Igt5+v1MnlxlMJRiJ/mhV6aVNAiKLSAZ49G/GdTQi1XiaxrHoc0r0zspmGkZ6jPFbgPVUF8JsY5Shk/QPOI4VIYzjzaV67cgLJYS7wVB8HXYMYAwMF/HUwRrXn6L734BAIuoAyDhhl0PbmYc3wMUtMcfIdsQ0chmnO3i/oOHApVGnspbDfw==",
  }
}


# vim: set ts=2 sw=2 et :
