#!/bin/bash

# Ubuntu 18.04

APP_DIRECTORY=empireasy
REPOSITORY=https://fc9@bitbucket.org/fc9/empireasy-app.git
EMAIL=fabiocabralsantos@gmail.com
NAME=fc9

echo " "
echo "### Iniciando instalacao do ambiente de Producao"

echo " "
echo "### Atualizando lista de pacotes disponiveis"
sudo apt-get update && apt-get upgrade --assume-yes

echo " "
echo "### Definindo Senha padrao para o MySQL e suas ferramentas"

DEFAULTPASS="root"
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

echo " "
echo "### Instalando pacotes basicos"
sudo apt-get install vim curl python-soinftware-properties git-core --assume-yes

echo " "
echo "### Adicionando Apache 2"
sudo apt-get install apache2 --assume-yes
sudo apt-get upgrade --assume-yes

echo " "
echo "### Instalando MySQL, Phpmyadmin e alguns outros modulos"
sudo apt-get install mysql-server mysql-client phpmyadmin --assume-yes
sudo mysql_secure_installation

echo " "
echo "### Iniciando MySQL"
sudo service mysql start

echo " "
echo "### Reiniciando Apache"
sudo service apache2 restart

echo " "
echo "### Instalando PHP 7.2"
sudo apt-get install php libapache2-mod-php --assume-yes

# ver os modulos PHP disponiveis
# sudo apt-cachesearch php7.2

echo " "
echo "### Ativando o repositório Universe"
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"

echo " "
echo "### Instalando alguns modulos do PHP 7.2"
# prevenir erros
sudo apt-get install php-zip php7.2-zip
# basicos
sudo apt-get install php7.2-cli php7.2-common php7.2-curl php7.2-gd php7.2-gmp php7.2-mysql php7.2-soap --assume-yes
# requirements for Laravel 6.x
sudo apt-get install php7.2-bcmath php7.2-ctype php7.2-json php7.2-mbstring php7.2-openssl php7.2-pdo php7.2-tokenizer php7.2-xml --assume-yes
# extras
sudo apt-get install php7.2-simplexml php7.2-sockets php7.2-sysvmsg php7.2-sysvsem php7.2-sysvshm --assume-yes
sudo apt-get install php7.2-wddx php7.2-xmlreader php7.2-xmlwrite php7.2-xsl --assume-yes

echo " "
echo "### Habilitando mod-rewrite do Apache"
sudo a2enmod rewrite
https://bitbucket.org/fc9/empireasy-app/admin/access-keys/
echo " "
echo "### Habilitando php7.2"
sudo a2enmod php7.2

echo " "
echo "### Reiniciando Apache"
sudo service apache2 restart

echo " "
echo "### Instalando pacotes para o Composer roda sem erros"https://bitbucket.org/fc9/empireasy-app/admin/access-keys/
sudo apt-get install zip unzip --assume-yes

echo " "
echo "### Baixando e Instalando Composer e movendo-o par a pasta de binarios local"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo " "
echo "### Criando arquivo teste"
echo '<?php phpinfo();' > /var/www/html/info.php

# Instale a partir daqui o que você desejar

echo " "
echo "### Instalando Laravel Installer com Composer"
composer global require laravel/installer

echo " "
echo "### Adicionar o binario do Laravel ao Path no ubuntu 18.04"
# sudo echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.bashrc
sudo echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bashrc
sudo -s
source ~/.bashrc 
su application
echo $PATH

echo " "
echo "### Criando usuario do Git"
git config --global user.email $EMAIL
git config --global user.name $NAME

echo " "
echo "### Gerando uma nova chave SSH para adicionar ao SSH agente."
echo " "
echo "Siga as instruções:  "
echo "- Quando aparecer \"Enter a file in which to save the key\", aperte ENTER."
echo "- Insira e confirme a senha de segurança."
echo "- Depois, copia a chave publica de \"/home/application/.ssh/id_rsa.pub\""
echo "- Adicione ao repositorio (https://bitbucket.org/fc9/$DIRECTORY-app/admin/access-keys/)." 
ssh-keygen -t rsa -b 4096 -C $EMAIL
vim /home/application/.ssh/id_rsa.pub

echo " "
echo "### Clonando projeto Laravel"
sudo chmod -R 777 /var/www
cd /var/www/
git clone $REPOSITORY $DIRECTORY
cd /var/www/$DIRECTORY
git remote -v

echo " "
echo "### Dando permissões de acesso"; 
sudo chmod -R 777 /var/www/$DIRECTORY/storage
sudo chmod -R 777 /var/www/$DIRECTORY/bootstrap/cache
sudo chmod -R 777 /var/www/$DIRECTORY/.env
sudo chown -R application:application /var/www/$DIRECTORY/public

echo " "
echo "### Atualizando o Composer"
cd /var/www/$DIRECTORY
composer install
composer update

echo " "
echo "### Alterando pasta raiz do servidor web"
sudo vim /etc/apache2/sites-available/000-default.conf
sudo service apache2 restart

echo " "
echo "### Configurando o arquivo de hosts"
sudo vim /etc/hosts

echo " "
echo "### Iniciando repositório"
cd /var/www/$DIRECTORY
git add .
git commit -m "Commit in producer"
git remote

echo " "
echo "[OK] Ambiente de producao concluido!"

# Garantir que deu tudo OK (code 0)
exit 0