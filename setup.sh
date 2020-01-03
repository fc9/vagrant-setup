#!/bin/bash

echo "---- Iniciando instalacao do ambiente de Desenvolvimento ---"

echo "--- Atualizando lista de pacotes disponiveis ---"
sudo apt-get update && apt-get upgrade --assume-yes

echo "--- Definindo Senha padrao para o MySQL e suas ferramentas ---"

DEFAULTPASS="vagrant"
sudo debconf-set-selections <<EOF
mysql-server	mysql-server/root_password password $DEFAULTPASS
mysql-server	mysql-server/root_password_again password $DEFAULTPASS
dbconfig-common	dbconfig-common/mysql/app-pass password $DEFAULTPASS
dbconfig-common	dbconfig-common/mysql/admin-pass password $DEFAULTPASS
dbconfig-common	dbconfig-common/password-confirm password $DEFAULTPASS
dbconfig-common	dbconfig-common/app-password-confirm password $DEFAULTPASS
phpmyadmin		phpmyadmin/reconfigure-webserver multiselect apache2
phpmyadmin		phpmyadmin/dbconfig-install boolean true
phpmyadmin      phpmyadmin/app-password-confirm password $DEFAULTPASS
phpmyadmin      phpmyadmin/mysql/admin-pass     password $DEFAULTPASS
phpmyadmin      phpmyadmin/password-confirm     password $DEFAULTPASS
phpmyadmin      phpmyadmin/setup-password       password $DEFAULTPASS
phpmyadmin      phpmyadmin/mysql/app-pass       password $DEFAULTPASS
EOF

echo "--- Instalando pacotes basicos ---"
sudo apt-get install vim curl python-software-properties git-core --assume-yes

echo "--- Adicionando Apache 2 ---"
sudo apt-get install apache2 --assume-yes
sudo apt-get upgrade --assume-yes

echo "--- Instalando MySQL, Phpmyadmin e alguns outros modulos ---"
sudo apt-get install mysql-server mysql-client phpmyadmin --assume-yes
sudo mysql_secure_installation

echo "--- Iniciando MySQL ---"
sudo service mysql start

echo "--- Reiniciando Apache ---"
sudo service apache2 restart

echo "--- Instalando PHP 7.2 ---"
sudo apt-get install php libapache2-mod-php --assume-yes

# ver os modulos PHP disponiveis
# sudo apt-cachesearch php7.2

echo "--- Ativando o repositório Universe ----"
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"

echo "--- Instalando alguns modulos do PHP 7.2 ---"
# prevenir erros
sudo apt-get install php-zip php7.2-zip
# basicos
sudo apt-get install php7.2-cli php7.2-common php7.2-curl php7.2-gd php7.2-gmp php7.2-mysql php7.2-soap --assume-yes
# requirements for Laravel 6.x
sudo apt-get install php7.2-bcmath php7.2-ctype php7.2-json php7.2-mbstring php7.2-openssl php7.2-pdo php7.2-tokenizer php7.2-xml --assume-yes
# extras
sudo apt-get install php7.2-simplexml php7.2-sockets php7.2-sysvmsg php7.2-sysvsem php7.2-sysvshm --assume-yes
sudo apt-get install php7.2-wddx php7.2-xmlreader php7.2-xmlwrite php7.2-xsl --assume-yes

echo "--- Habilitando mod-rewrite do Apache ---"
sudo a2enmod rewrite

echo "-- Habilitando php7.2 ---"
sudo a2enmod php7.2

echo "--- Reiniciando Apache ---"
sudo service apache2 restart

echo "-- Instalando pacotes para o Composer roda sem erros ---"
sudo apt-get install zip unzip --assume-yes

echo "--- Baixando e Instalando Composer e movendo-o par a pasta de binarios local ---"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo "--- Criando arquivo teste ---"
echo '<?php phpinfo();' > /var/www/html/info.php

# Instale a partir daqui o que você desejar

echo "--- Instalando Laravel Installer com Composer ---"
composer global require laravel/installer

echo "--- Adicionar o binario do Laravel ao Path no ubuntu 18.04 ---"
sudo echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.bashrc
sudo source ~/.bashrc --assume-yes
echo $PATH

#echo "--- Criando projeto ---"
cd /var/www/
laravel new blog
cd /var/www/blog
composer update

echo "--- Criando usuario do Git ---"
git config --global user.email "fabiocabralsantos@gmail.com"
git config --global user.name "fc9"

echo "[OK] --- Ambiente de desenvolvimento concluido ---"

# Garantir que deu tudo OK (code 0)
exit 0

# Restaurando .bashrc para o padrao
#cp ~/.bashrc ~/.bash.old
#cp /etc/skel/.bashrc ~/
#source ~/.bashrc

# Instalar o iptables
#apt-get install iptables

# Instalar o Netstat
# netstat is a command-line tool that can provide information about network connections, including IP addresses, ports and services communicating on these ports..
#sudo apt-get install net-tools --assume-yes
