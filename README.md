# Land Registry's RabbitMQ Install

A puppet module to manage the RabbitMQ install and configuration

## Requirements

* A [Puppet](https://puppet.com/product/open-source-projects) Master server version 3.8.
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
| **Certificate usage** | only if SSL/TLS has been enabled | --- |
| rabbitmq_server_key | The OpenSSL server key
| rabbitmq_server_cert | The OpenSSL server certificate, this key pair is use for the cluster communication and queue sync.
| rabbitmq_client_key | The OpenSSL client key
| rabbitmq_client_cert | The OpenSSL client certificate, this key pair is needed to gain access to the rabbitmq server or cluster.
| rabbitmq_origin_key | The OpenSSL remote client key
| rabbitmq_origin_cert | The OpenSSL remote client certificate, this key pair is needed to gain access to a remote server or cluster.
| root_ca_cert | The OpenSSL CA signing certificate is required to verify the certoificate signatures.

##### Also create a YAML file in the secrets repo inside the 'network_location' folder to provide the cwcertificate variables for the cluster using the following basic examples:

```

# This hiera configuration is for the network_location config
# -----------------------------------------------------------


# this is a self signed vagrant_development key.
# md5sum : _<md5sum>_  rabbit-server.key
#
rabbitmq_server_key: |
  -----BEGIN RSA PRIVATE KEY-----
  bla bla bla
  -----END RSA PRIVATE KEY-----

# this is a self signed vagrant_development cert.
# md5sum : _<md5sum>_  rabbit-server.crt
#
rabbitmq_server_cert: |
  -----BEGIN CERTIFICATE-----
  bla bla bla
  -----END CERTIFICATE-----

# this is a self signed vagrant_development key.
# md5sum : _<md5sum>_  rabbit-client.key
#
rabbitmq_client_key: |
  -----BEGIN RSA PRIVATE KEY-----
  bla bla bla
  -----END RSA PRIVATE KEY-----

# this is a self signed v3yyagrant_development cert.
# md5sum : _<md5sum>_  rabbit-client.crt
#
rabbitmq_client_cert: |
  -----BEGIN CERTIFICATE-----
  bla bla bla
  -----END CERTIFICATE-----

# this is a self sign root CA cert.
# md5sum : _<md5sum>_  root_cacert.pem
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


#### Creating a certificate for a rabbitmq cluster ( beware a certificate error costs loads of hours of debugging !! )

Follow the guide on the [Cloud Wiki](https://webops-cloud.diti.lr.net/WebOps_Cloud_Wiki/openssh_openssl_server_certs).
Obviouesly, the server names and IP addresses are listed for demonstration puposes only. Replace them to fit your environment.

##### First the server: Watch out for the little word **server** !!!

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

##### Second the client:, repeat all, replacing every **server** with **client** !!!

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

The next command need to be run on the client:

`openssl s_client -connect <server_ip>:8443 -cert /etc/rabbitmq/ssl/rabbitmq-client.crt -key /etc/rabbitmq/ssl/rabbitmq-client.key`

Both sides have now more or less blurb. If nothing is being printed on the screens, revoke the certs and start again.

On the server the last line should say: (otherwise: revoke the certs and start again)
```
Secure Renegotiation IS supported
```

On the client the last line should say: (otherwise: revoke the certs and start again)
```
Verify return code: 0 (ok)
```

##### Last hurdle to pass is the Puppet run.

When the puppet run fails to create the exchange and the queue, run puppet again with full debug and try to spot the error. If it is something like cert error or server name error you highly likely have a mistake in the hosts file, the DNS and the SUB_ALT names in the certificate. Check that all matches up correctly and if necessary revoke the certs and start again.


##### Another part in the set-up is Firewalls and selinux.

Ensure the following ports are open and usable that is **network** and **selinux**:
```
4369: epmd, a peer discovery service used by RabbitMQ nodes and CLI tools
5672: used by AMQP 0-9-1 and 1.0 clients without TLS
5671: used by AMQP 0-9-1 and 1.0 clients with TLS
15671: used by rabbimqadmin with TLS
25672: used by Erlang distribution for inter-node and CLI tools communication
```


##### Clustering and general troubleshooting

Clustering is set-up automatically with a correct config and the correct network/selinux configuration.
Should this not happen, it can be a painful process to find out what isn't correct. RabbitMQ has created an excellent page on their website.

https://www.rabbitmq.com/clustering.html


##### Monitoring, Managing etc

Since it is rather complicated to use the provided rabbitmqadmin tool when TLS is enabled, I wrote a little wrapper script providing every variable required.
This little wrapper script is also used in my puppet module to set-up the exchange and queue.

Run this to check the queues:  `/usr/local/bin/rabbit_admin.sh list queues`

Run this for checking the status:  `rabbitmqctl status`  The output is lots, but you will see when it errors.

Run this for checking the cluster: `rabbitmqctl cluster_status`  This prints the configured cluster nodes and running nodes.



##### Documentation

https://www.rabbitmq.com

### License

Please see the [LICENSE](https://github.com/LandRegistry-Ops/puppet-x-rabbitmq/blob/master/LICENSE.md) file.

