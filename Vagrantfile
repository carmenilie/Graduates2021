HOSTS = {
  :controller => { :hostname => 'controller.local', 	   :ip => '192.168.50.10',   :memory => '512',   :cpu => "1",  :autostart => true},
  :jenkins    => { :hostname => 'jenkinsProiect.local',    :ip => '192.168.50.21',   :memory => '1024',  :cpu => "1",  :autostart => true},
  :production => { :hostname => 'production.local', 	   :ip => '192.168.50.22',   :memory => '512',   :cpu => "1",  :autostart => true},
}

$controller_shell = <<SCRIPT

  echo "Running script on Controller"
  apt-get update >/dev/null
  apt-get install software-properties-common -y
  apt-add-repository ppa:ansible/ansible
  apt-get update >/dev/null
  apt-get install ansible tree mc git zip unzip -y

  echo "Generating ssh keys"  
  ssh-keygen -t rsa -N '' -q -f /home/vagrant/.ssh/id_rsa
  cp -f /home/vagrant/.ssh/id_rsa.pub /vagrant/ssh/id_rsa.pub
  cp -f /home/vagrant/.ssh/id_rsa /vagrant/ssh/id_rsa
  cp /vagrant/ssh/config /home/vagrant/.ssh/config
  chmod 600 /home/vagrant/.ssh/config
  cp /vagrant/ssh/git_key /home/vagrant/.ssh/git_key
  chmod 600 /home/vagrant/.ssh/git_key

  echo "Configuring authorized_keys "
  (echo ; cat /vagrant/ssh/id_rsa.pub) >> /home/vagrant/.ssh/authorized_keys
  chmod 640 /home/vagrant/.ssh/authorized_keys

  # bash configuration
  cp /vagrant/bash/bash_profile /home/vagrant/.bash_profile

  # some files might be owned by root, so do this to fix it
  chown vagrant:vagrant /home/vagrant/ -R
  
  echo "SUCCESS"
 
SCRIPT

$others_shell = <<SCRIPT

  apt-get update >/dev/null

  echo "Configuring authorized_keys "
  cat /vagrant/ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
  chmod 640 /home/vagrant/.ssh/authorized_keys
  
  echo "SUCCESS"

SCRIPT

# Install additional plugins if required
required_plugins = %w( vagrant-vbguest vagrant-hosts vagrant-share )
required_plugins.each do |plugin|
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

# Vagrant.configure("2") returns the Vagrant configuration object for the new box. 
# In the block, we'll use the "config" alias to refer this object. 
# Use version 2 of Vagrant API.
Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/bionic64"
  config.vm.box_check_update = false
  config.vm.synced_folder "../", "/vagrant", owner:"vagrant", mount_options: ["dmode=755,fmode=755"]
  config.vbguest.no_remote = true
  config.vbguest.auto_update = true
  config.ssh.insert_key = true

  config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

	HOSTS.each do |name, host|

		config.vm.define name, autostart: host[:autostart] do |d|
			d.vm.network "private_network", ip: host[:ip]
		  d.vm.provision :hosts, :sync_host => true
			d.vm.hostname = host[:hostname]

      d.vm.provider "virtualbox" do |v|
        v.gui = false
        v.name = host[:hostname]
        v.memory = host[:memory]
        v.cpus = host[:cpu]
				v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
	  		v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      end

      case name.to_s
        when "controller"
          then d.vm.provision "shell", inline: $controller_shell, privileged: true#, run: "always"
        else d.vm.provision "shell", inline: $others_shell, privileged: true#, run: "always"
      end

    end
	end
end