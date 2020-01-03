# Definindo um ambiente de desenvolvimento

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

```laravel new *blog*```

### Via create-project do Composer

```composer create-project --prefer-dist laravel/laravel *blog*```

Configuração
============

### Diretório *public*

Configure o diretório *public* como raiz do servidor web ou configure um **virtual host** apontando a raiz para pasta *public*.

### Arquivo de configuração de ambiente *.env*

Edite o arquivo **.env** com os dados do projeto, por exemplo: conexão com o banco de dados.

### Permissões de diretório

