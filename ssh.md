# SSH

## Movendo arquivos

```ssh username@domain_or_ip```

Copiando para máquina local:

```scp user@RemoteIP:/home/dirRemote/file.txt /home/dirLocal/```

Enviando para um servidor remoto:

```scp /home/dirLocal/file.txt user@remoteIP:/home/dirRemote/file.txt```

## Movendo pastas e subpastas

Copiando para máquina local:

```scp -r user@remoteIP:/home/path.../folder/ /home/dirLocal/folder```

Enviando para um servidor remoto:

```scp -r /home/dirLocal/folder/ user@iremoteIP:/home/path.../folder/```

Outros
======

Como apagar uma chave ssh da lista de chaves conhecidas

```ssh-keygen -f "/home/myUser/.ssh/known_hosts" -R domain_or_ip```

Fontes
======

https://www.alura.com.br/artigos/como-acessar-servidores-remotamente-com-ssh

https://www.linode.com/community/questions/413/i-get-the-error-permission-denied-publickey-when-i-connect-with-ssh

[Como Configurar Chaves SSH no Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/como-configurar-chaves-ssh-no-ubuntu-18-04-pt)
