# Land Registry's RabbitMQ Install

A puppet module to manage the RabbitMQ install and configuration

## Requirements

* Puppet  >=  3.4
* The [stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib) Puppet library.
* The [rabbitmq](https://forge.puppetlabs.com/puppetlabs/rabbitmq) Puppet Module RabbitMQ.
* The [wget](https://forge.puppetlabs.com/maestrodev/wget) Puppet Module wget.
* The [erlang](https://forge.puppetlabs.com/garethr/erlang) Puppet Module Erlang.
* The [staging](https://forge.puppetlabs.com/nanliu/staging) Puppet Module Staging Handling.
* The [selinux](https://forge.puppet.com/jfryman/selinux) Puppet Module selinux.

## Usage

### Main class

```
class ( 'rabbit' )

This puppet module installs the RabbitMQ server including user and queues for log messages.

```

### License

Please see the [LICENSE](https://github.com/LandRegistry-Ops/puppet-x-rabbitmq/blob/master/LICENSE.md) file.

