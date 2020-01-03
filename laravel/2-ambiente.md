# Definindo um ambiente de desenvolvimento

> substitua **blog** pelo nome de diretorio do seu projeto.

### Requisitos de sistema:

- PHP >= 7.2.0
- Extensão PHP BCMath
- Extensão PHP de tipo
- Extensão PHP JSON
- Extensão PHP Mbstring
- Extensão PHP OpenSSL
- Extensão PHP DOP
- Extensão PHP do tokenizador
- Extensão XML PHP

Outros

- Git
- Composer
- Vim
- MySQL 5.5

O arquivo setup.sh tem um script para instalação e configuração automática.

Criando um novo projeto Laravel
===============================

### Via Laravel Installer

> Edite e execute o arquivo [setup.sh](../setup.sh) para configurar o ambiente com Laravel Installer.

Com a ferramenta instalada, basta executar o comando a seguir para criar um diretório **blog** com uma novo projeto do Laravel:

```laravel new blog```

### Via create-project do Composer

```composer create-project --prefer-dist laravel/laravel blog```

Configuração
============

### Diretório *public*

Configure o diretório *public* como raiz do servidor web ou configure um **virtual host** apontando a raiz para pasta *public*.

### Arquivo de configuração de ambiente *.env*

Edite o arquivo *.env* com os dados do projeto, por exemplo: conexão com o banco de dados.

### Permissões de diretório

O diretório *storage* devem ser gravável ​​pelo servidor Web ou o Laravel não será executado:

```sudo chmod -R 777 /var/www/blog/storage```

> Se você estiver usando a máquina virtual [Homestead](https://laravel.com/docs/6.x/homestead), essas permissões já deverão estar definidas em *bootstrap/cache*.

O arquivo de configuração de ambiente também:

```sudo chmod -R 777 /var/www/blog/.env```

### Chave do aplicativo

Defina uma *app key* com uma sequência aleatória que deve ter 32 caracteres. A chave pode ser configurada no arquivo de ambiente *.env*. **Se a chave do aplicativo não estiver definida, suas sessões do usuário e outros dados criptografados não serão seguros!**.

> Se você instalou o Laravel via Composer ou o Laravel Installer, essa chave já foi definida para você pelo comando ```php artisan key:generate```.

Adicionais
==========

### Atualize as dependências

```
cd /var/www/blog
composer update
```

### Inicie o repositório do projeto

```
cd /var/www/blog
git init
git add .
git commit -m "Initial commit"
```