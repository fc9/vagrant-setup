Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu-18.04-lts-amd64"
    config.vm.box_url = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64-vagrant.box"
    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.network :private_network, ip: "192.168.33.9"
    config.vm.synced_folder "www/", "/var/www", owner: "www-data", group: "www-data", mount_options: ['dmode=777','fmode=666']
    config.vm.synced_folder "~", "/vagrant", owner: "vagrant", group: "vagrant"
    config.vm.provider "virtualbox" do |machine|
        machine.memory = 2048
        machine.name = "ubuntu18.04"
    end
    config.vm.provision :shell, path: "setup.sh"
end