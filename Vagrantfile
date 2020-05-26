# -*- mode: ruby -*-
# vi: set ft=ruby :

vms = {
  'manager' => {'memory' => '2048', 'cpus' => 2, 'ip' => '10', 'provision' => 'manager.sh'},
  'worker1' => {'memory' => '2048', 'cpus' => 1, 'ip' => '20', 'provision' => 'worker.sh'},
  'worker2' => {'memory' => '2048', 'cpus' => 1, 'ip' => '30', 'provision' => 'worker.sh'},
  'storage' => {'memory' => '256', 'cpus' => 1, 'ip' => '40', 'provision' => 'storage.sh'},
}

Vagrant.configure('2') do |config|

  config.vm.box = 'debian/buster64'
  config.vm.box_check_update = false

  vms.each do |name, conf|
    config.vm.define "#{name}" do |k|
      k.vm.hostname = "#{name}.example.com"
      k.vm.network 'private_network', ip: "172.27.11.#{conf['ip']}"
      k.vm.provider 'virtualbox' do |vb|
        vb.memory = conf['memory']
        vb.cpus = conf['cpus']
      end
      k.vm.provider 'libvirt' do |lv|
        lv.memory = conf['memory']
        lv.cpus = conf['cpus']
        lv.cputopology :sockets => 1, :cores => conf['cpus'], :threads => '1'
      end
      k.vm.provision 'shell', path: "provision/#{conf['provision']}"
    end
  end

  config.vm.provision 'shell', path: 'provision/base.sh'
end
