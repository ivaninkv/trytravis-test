# ivaninkv_infra
ivaninkv Infra repository


## Настройка SSH Forwarding на локальной машине

```
eval `ssh-agent -s`
ssh-add -L
ssh-add ~/.ssh/appuser
```

## Подключение к внутреннему хосту в одну команду

Для подключения в одну команду можно воспользоваться механизмом `ProxyJump`.
Команда должна быть следующего вида `ssh -J appuser@35.207.68.82 appuser@10.156.0.3`

## Подключение к внутреннемму хосту через алиас

Для подключения через алиас необходимо создать конфиг `~/.ssh/config` следующего вида

```
### The Bastion Host
Host bastion
        HostName 35.207.68.82
        User appuser
        IdentityFile ~/.ssh/appuser

### The Remote Host
Host someinternalhost
        HostName 10.156.0.3
        User appuser
        IdentityFile ~/.ssh/appuser
        ProxyJump bastion
```

[Источник](https://www.redhat.com/sysadmin/ssh-proxy-bastion-proxyjump)


## Настройка VPN

```
bastion_IP = 35.207.68.82
someinternalhost_IP = 10.156.0.3
```
