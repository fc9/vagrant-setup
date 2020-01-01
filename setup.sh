#!/bin/bash

echo "---- Iniciando instalacao do ambiente de Desenvolvimento ---"

echo "--- Atualizando lista de pacotes disponiveis ---"
sudo apt update && apt dist-upgrade

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
sudo apt install vim curl python-software-properties git-core --assume-yes --force-yes

echo "--- Adicionando Apache 2 ---"
sudo apt install apache2

echo "--- Instalando MySQL, Phpmyadmin e alguns outros modulos ---"
sudo apt install mysql-server mysql-client phpmyadmin --assume-yes --force-yes
mysql_secure_installation

echo "--- Iniciando MySQL ---"
sudo service mysql start

echo "--- Reiniciando Apache ---"
sudo service apache2 restart

echo "--- Instalando PHP 7.2 ---"
sudo apt install php libapache2-mod-php --assume-yes --force-yes

# ver os modulos PHP disponiveis
# sudo apt-cachesearch php7.2

echo "---- Instalando alguns modulos do PHP 7.2 ---"
sudo apt install php7.2-curl php7.2-cli php7.2-common php7.2-tokenizer php7.2-mbstring php7.2-xml php7.2-mysql php7.2-json php7.2-soap php7.2-gd php7.2-gmp php7.2-xsl  php7.2-xmlwrite php7.2-xmlreader php7.2-wddx php7.2-sysvshm php7.2-sysvmsg php7.2-sysvsem php7.2-sockets php7.2-simplexml --assume-yes --force-yes

echo "--- Habilitando mod-rewrite do Apache ---"
sudo a2enmod rewrite

echo "-- Desabilitando o modulo php7 e habilitando php7.2 ---"
sudo a2dismod php7
sudo a2enmod php7.2

echo "--- Reiniciando Apache ---"
sudo service apache2 restart

echo "--- Baixando e Instalando Composer globalmente ---"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo "-- Instalando pacotes para o Composer roda sem erros ---"
sudo apt install zip unzip --assume-yes

echo "--- Criando arquivo teste ---"
sudo echo "<?php phpinfo();>" /var/www/html/info.php

# Instale a partir daqui o que você desejar

echo "[OK] --- Ambiente de desenvolvimento concluido ---"

# Garantir que deu tudo OK (code 0)
exit 0