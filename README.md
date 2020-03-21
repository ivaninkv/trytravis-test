# ivaninkv_infra
ivaninkv Infra repository

## HomeWork 3 Bastion

### Настройка SSH Forwarding на локальной машине

```
eval `ssh-agent -s`
ssh-add -L
ssh-add ~/.ssh/appuser
```

### Подключение к внутреннему хосту в одну команду

Для подключения в одну команду можно воспользоваться механизмом `ProxyJump`.
Команда должна быть следующего вида `ssh -J appuser@35.207.68.82 appuser@10.156.0.3`

### Подключение к внутреннемму хосту через алиас

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


### Настройка VPN

```
bastion_IP = 35.207.68.82
someinternalhost_IP = 10.156.0.3
```

## HomeWork 4 Cloud-TestApp

### Информация для автоматической проверки

```
testapp_IP = 34.89.157.77
testapp_port = 9292
```

### Команда для создания инстанса и передачи startup-script из локального файла

```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=startup-script.sh
```

### Команда для создания инстанса и передачи startup-script из url

```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script-url=https://gist.githubusercontent.com/ivaninkv/804185b5bc8aa47f2d1ba355a5d445bf/raw/ed35717e1876c7742e3c0dc3850ac3cd36bd0553/startup-script.sh
```

### Команда для создания правила в фаерволе

```
gcloud compute firewall-rules create default-puma-server\
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:9292 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=puma-server
```
