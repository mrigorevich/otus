# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :dz16 => {
        :box_name => "ubuntu/jammy64",
        :vm_name => "dz16",
        :ip => "192.168.11.150",
       }
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, settings|
    config.vm.define settings[:vm_name] do |node|
      node.vm.box = settings[:box_name]
      node.vm.hostname = settings[:vm_name]
	  node.vm.synced_folder ".", "/vagrant", disabled: true
	  node.vm.network "private_network", ip: settings[:ip]
      node.vm.provider "virtualbox" do |vb|
        vb.name = settings[:vm_name]
        vb.memory = "1024"
        vb.cpus = 1
      end
      
      node.vm.provision "shell", inline: <<-SHELL
# включаем парольную аутентификацию
		cat <<EOF > /etc/ssh/sshd_config.d/90-vagrant-password.conf
PasswordAuthentication yes
KbdInteractiveAuthentication yes
EOF
		systemctl restart ssh.service

# устанавливаем docker для задания со звездочкой
        apt-get update -y
        apt-get install -y docker.io docker-compose-v2
      
# выполняем задание со звездочкой и разрешаем пользователю vagrant запускать docker без sudo
        usermod -aG docker vagrant
      SHELL
    end
  end
end