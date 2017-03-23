# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.7.4"

Vagrant.configure(2) do |conf|
  conf.vm.box = "landregistry/centos"
  conf.vm.synced_folder ".yum", "/var/cache/yum"
  conf.vm.synced_folder ".gem", "/usr/local/share/gems/cache/"

  conf.vm.provision "shell", inline: <<-SCRIPT
    sed -i -e 's,keepcache=0,keepcache=1,g' /etc/yum.conf
    sed -i -e 's,#PermitRootLogin,PermitRootLogin,g' /etc/ssh/sshd_config
    cp /vagrant/tests/hosts.vagrant.conf /etc/hosts
    systemctl restart sshd
    yum install -y git telnet
    puppet module install puppetlabs-vcsrepo
    puppet module install puppetlabs-stdlib
    puppet module install puppetlabs-rabbitmq
    puppet module install maestrodev/wget
    puppet module install garethr-erlang
    puppet module install jfryman-selinux
    cd /etc/puppet/
    ln -s /vagrant/tests/hiera.vagrant.yaml /etc/puppet/hiera.yaml
    cd /etc/puppet/modules
    ln -s /vagrant /etc/puppet/modules/rabbit
    puppet apply /vagrant/tests/init.pp
  SCRIPT

  conf.vm.define "server3" do |web|
    web.vm.host_name = "server3"
    web.vm.network "private_network", :ip => "192.168.42.51"
  end

  conf.vm.define "server4" do |web|
    web.vm.host_name = "server4"
    web.vm.network "private_network", :ip => "192.168.42.52"
  end

  conf.vm.define "server5" do |web|
    web.vm.host_name = "server5"
    web.vm.network "private_network", :ip => "192.168.42.53"
  end

  conf.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', ENV['VM_MEMORY'] || 2048]
    vb.customize ['modifyvm', :id, '--vram', ENV['VM_VIDEO'] || 24]
    vb.customize ["modifyvm", :id, "--cpus", ENV['VM_CPUS'] || 4]
  end
end
