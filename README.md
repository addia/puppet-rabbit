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

##### Create a YAML file in the secrets repo inside the 'cluster' folder to build a server or a cluster for RabbitMQ using the following basic examples:

```

classes:
  - 'rabbit'

rabbitmq_clustername: addis-rabbit-cluster

rabbitmq_data_nic:  eth1

rabbitmq_master: server3.<domain>

rabbitmq_servers:  ['server3.<domain>', 'server4.<domain>', 'server5.<domain>']

rabbitmq_cookie:  "52J3TP2U765WLRZPVF4M"   <<<---20 charecters

rabbitmq_passwd:  "CXTD6EMPJW2HYK58"       <<<---16 charecters

logstash_passwd:  "3CB54FY3JKXTRG5J"       <<<---16 charecters

logstash_key:  "T7GP7649PBRANMN3"          <<<---16 charecters


```

##### Explanations of all mandatory and optional hiera variables

| Variable | Description | Comments |
| --- | --- | --- |
| rabbitmq_clustername | The rabitmq cluster name
| rabbitmq_master | The initial master node, for set-up requirements
| rabbitmq_servers | The servers to build a cluster
| rabbitmq_cookie | The database cookie | any change in the cookie will completely initialize the database
| rabbitmq_passwd | The server password
| logstash_passwd | The pasword for logstash
| logstash_key | The logstash key
| **Cluster extras** | --- | --- |
| rabbitmq_origin_conf | The default is false, set it to true for rabbitmq transport
| rabbitmq_origin | The default is undef, the rabbit cluster address to pull the queue from
| rabbitmq_origin_passwd | The default is undef, the remote rabbit cluster password
| rabbitmq_origin_passkey | The default is undef, the remote rabbit cluster key


##### Also create a YAML file in the secrets repo inside the 'network_location' folder to provide the cwcertificate variables for the cluster using the following basic examples:

```

# This hiera configuration is for the network_location config
# -----------------------------------------------------------


# this is a self signed vagrant_development key.
# md5sum : 368e44433b6dafad89c2093b967662f3  rabbit-server.key
#
rabbitmq_server_key: |
  -----BEGIN RSA PRIVATE KEY-----
  bla bla bla
  -----END RSA PRIVATE KEY-----

# this is a self signed vagrant_development cert.
# md5sum : 420106c5697abc599f6ea8024341286a  rabbit-server.crt
#
rabbitmq_server_cert: |
  -----BEGIN CERTIFICATE-----
  bla bla bla
  -----END CERTIFICATE-----

# this is a self signed vagrant_development key.
# md5sum : af092350308c45fc51a328d0cb96279d  rabbit-client.key
#
rabbitmq_client_key: |
  -----BEGIN RSA PRIVATE KEY-----
  bla bla bla
  -----END RSA PRIVATE KEY-----

# this is a self signed v3yyagrant_development cert.
# md5sum : a23dacf1f025feface250519219ee870  rabbit-client.crt
#
rabbitmq_client_cert: |
  -----BEGIN CERTIFICATE-----
  bla bla bla
  -----END CERTIFICATE-----

# this is a self signed vagrant_development key.
# md5sum : a833b812125330a094178fe7ad20d591  vagrant_devel.key
#
els_elastic_key: |
  -----BEGIN RSA PRIVATE KEY-----
  bla bla bla
  -----END RSA PRIVATE KEY-----

# this is a self signed vagrant_development cert.
# md5sum : a28335250a72ef55e671b3db355ccc50  vagrant_devel.crt
#
els_elastic_cert: |
  -----BEGIN CERTIFICATE-----
  bla bla bla
  -----END CERTIFICATE-----

# this is a self sign root CA cert.
# md5sum : b19458bf253b9ddb1d1715af166e80bd  root_cacert.pem
#
root_ca_cert: |
  -----BEGIN CERTIFICATE-----
  bla bla bla
  -----END CERTIFICATE-----

# The next 2 certs are only required when pulling from a remote rabbit cluster:
# -----------------------------------------------------------------------------
#
# this is a self signed vagrant_development key.
# md5sum :
#
rabbitmq_origin_key: |
  -----BEGIN RSA PRIVATE KEY-----
  bla bla bla
  -----END RSA PRIVATE KEY-----

# this is a self signed vagrant_development crt.
# md5sum :
#
rabbitmq_origin_cert: |
  -----BEGIN CERTIFICATE-----
  bla bla bla
  -----END CERTIFICATE-----

```


##### Creating a certificate for a rabbitmq cluster ( beware a certificate error costs loads of hours of debugging !! )

Follow the guide on the [Cloud Wiki](https://webops-cloud.diti.lr.net/WebOps_Cloud_Wiki/openssh_openssl_server_certs).

First the server: Watch out for the little word **server** !!!

```

export SERVICE=rabbit-server
--->>> create or re-use the key, see guide.

export SERVICE_KEY=${SERVICE}.key
export SUBJ="/C=GB/ST=Devon/L=Plymouth/O=server/CN=${SERVICE}"
export SUBJ_ALT_NAME="DNS:rabbit1, DNS:rabbit1.abel.uk.com, DNS:rabbit2.abel.uk.com, DNS:rabbit3.abel.uk.com, DNS:server3.abel.de.com, DNS:server4.abel.de.com, DNS:server5.abel.de.com, IP:192.168.122.180, IP:192.168.122.181, IP:192.168.122.182, IP:192.168.42.51, IP:192.168.42.52, IP:192.168.42.53"

--->>> create the certificate request, see guide.

openssl req -config ./conf/openssl-req.conf -new -key ${SERVICE_KEY} -out ${SERVICE}.req -outform PEM -subj ${SUBJ} -nodes

--->>> get the cert signed or self-sign, see guide.
openssl ca -batch -notext -config ./conf/openssl-sign.cnf -in ${SERVICE}.req -out ${SERVICE}.crt  -extensions server_ca_extensions

```

Second the client:, repeat all, replacing every **server** with **client** !!!

```

export SERVICE=rabbit-client
--->>> create or re-use the key, see guide.

export SERVICE_KEY=${SERVICE}.key
export SUBJ="/C=GB/ST=Devon/L=Plymouth/O=client/CN=${SERVICE}"
export SUBJ_ALT_NAME="DNS:rabbit1, DNS:rabbit1.abel.uk.com, DNS:rabbit2.abel.uk.com, DNS:rabbit3.abel.uk.com, DNS:server3.abel.de.com, DNS:server4.abel.de.com, DNS:server5.abel.de.com, IP:192.168.122.180, IP:192.168.122.181, IP:192.168.122.182, IP:192.168.42.51, IP:192.168.42.52, IP:192.168.42.53"
-->>> create the certificate request, see guide.

openssl req -config ./conf/openssl-req.conf -new -key ${SERVICE_KEY} -out ${SERVICE}.req -outform PEM -subj ${SUBJ} -nodes

--->>> get the cert signed or self-sign, see guide.
openssl ca -batch -notext -config ./conf/openssl-sign.cnf -in ${SERVICE}.req -out ${SERVICE}.crt  -extensions client_ca_extensions

```

##### Next part is testing the certs.

Copy the server certs to a machine with an IP mentioned in the server certificate. Then copy the client certs to a different server with an IP mentioned in the client certificate.

On the server run the following command:

`openssl s_server -accept 8443 -cert /etc/rabbitmq/ssl/rabbitmq-server.crt -key /etc/rabbitmq/ssl/rabbitmq-server.key`

The initial utput is:
```
Using default temp DH parameters
Using default temp ECDH parameters
ACCEPT
```

```

```

### License

Please see the [LICENSE](https://github.com/LandRegistry-Ops/puppet-x-rabbitmq/blob/master/LICENSE.md) file.

