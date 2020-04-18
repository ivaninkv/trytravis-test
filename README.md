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

## HomeWork 5 Сборка образов при помощи Packer

- Был собран базовый образ с помощью Packer, с установленным Ruby и MongoDB
  - `packer build -var-file=variables.json ubuntu16.json`
- Из образа был запущен инстанс ВМ и вручную установлено приложение
- Изучен механизм параметризации шаблонов Packer, для примера приложен файл variables.json.example
- Создан `baked` образ с установленным приложеним, в котором устанавливается приложение и настраивается автозапуск через [systemd](https://github.com/puma/puma/blob/master/docs/systemd.md)
- Написана команда создания инстанса из `baked` образа


### Команда для создания инстанса из своего образа

```
gcloud compute instances create reddit-app-full\
  --boot-disk-size=10GB \
  --image=reddit-full-1584813002 \
  --machine-type=g1-small \
  --tags puma-server \
  --zone=europe-west3-c	\
  --restart-on-failure
```

## HomeWork 6 Практика IaC с Terraform

**Основное ДЗ**

- Был описан файл `main.tf` и развернута инфраструктура на его основе.
  - Развернули базовый образ
  - Добавили ssh-ключ
  - Добавили правило файервола
  - Добавили тэги
- Был добавлен файл `outputs.tf` для вывода значений в консоль при создании инстанса
  - `app_external_ip`
- Был добавлен файл `variables.tf` в котором описаны некоторые переменные
- Был добавлен файл `terraform.tfvars` в котором прописаны значения переменных

**Задание со***

* Добавлены `SSH`-ключи для пользователей `appuser1` и `appuser2` в метаданные проекта. Документация по [ссылке](https://www.terraform.io/docs/providers/google/r/compute_project_metadata.html).
* При добавлении `ssh`-ключей через `Terraform`, все ключи, созданные через web-интерфейс ***удаляются***.

**Задание с****

* С помощью изучения исходного кода [репозитория](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/examples/network-load-balancer/main.tf) был настроен балансер.
* В параметры вынесено количество создаваемых инстансов, со значением по умолчанию = 1.

**Проблемы текущей реализации**

* Текущая конфигурация подразумевает несколько инстансов с приложением и БД, которая находится на том же инстансе. Основная проблема - синхронизация данных, её сейчас нет и каждый экземпляр приложения работает со своей БД.


## HomeWork 7 Принципы организации инфраструктурного кода

**Основное ДЗ**

* Добавили правило файервола по умолчанию для `SSH`.
* Импортировали существующее правило в `terraform.tfstate`.
* Проверили неявные зависимости на примере IP адреса ресурса.
* Разбили конфиг `main.tf` на несколько файлов:
  * `app.tf`
  * `db.tf`
  * `vpc.tf`
* Подготовленные на предыдущем шаге файлы превратили в модули для повторного переиспользования.
* Постарались максимально параметризировать модули для более гибкого испольщования. Для многих параметров задали умолчания.
* Создали окружение `stage` и `prod`, в которых использовали созданные ранее модули.
* Проверили работу с реестром модулей на примере модуля `"SweetOps/storage-bucket/google"`.

**Задание со***

* Для директорий `prod` и `stage` было настроено хранение стейт файла на `Google Cloud Storage`, с помощью файла `backend.tf`.
* Были удалены файлы `terraform.tfstate` и запущены параллельно команды в каталоге `satge` и его копии. В одном случае получаем ошибку блокировки:
```
Error: Error locking state: Error acquiring the state lock: writing "gs://storage-bucket-ikv/gcs-app/default.tflock" failed: googleapi: Error 412: Precondition Failed, conditionNotMet
Lock Info:
  ID:        1585717410080232
  Path:      gs://storage-bucket-ikv/gcs-app/default.tflock
  Operation: OperationTypeApply
  Who:       const@notebook
  Version:   0.12.24
  Created:   2020-04-01 05:03:31.7583012 +0000 UTC
  Info:


Terraform acquires a state lock to protect the state from being written
by multiple users at the same time. Please resolve the issue above and try
again. For most commands, you can disable locking with the "-lock=false"
flag, but this is not recommended.
```
* Из обеих директорий (оригинала и копии) видно состояние инфраструктуры.

**Задание с****

* Добавлены `provisioners` для деплоя приложения и применения необходимых настроек:
  * Прописывание `DATABASE_URL`
  * Изменение конфигурации `MongoDB` для доступа с других ВМ.

**Что не получилось сделать**

* Хотелось добавить в конфигурацию `MongoDB` только IP адрес приложения, а не `0.0.0.0`. Для этого был добавлен хост `bastion`, для подключения к серверу БД. Но не смог разобраться как выполнить скрипт на произвольной машине, после создания всех инстансов и получения всех нужных адресов.
* Не реализовал отключение `provisioners` - на эту задачу не осталось ни сил, ни желания.

## HomeWork 8 Знакомство с Ansible

**Основное задание**

* Установили `Ansible`
* Создали `inventory` файл в `ini` формате
* Создали `inventory` файл в `yml` формате
* Создали `ansible.cfg`
* Научились выполнять команды на удаленных серверах с помощью
  * command - лучше использовать этот вариант, т.к. он имеет структурированный вывод и идемпотентность
  * shell - это шелл во всей своей красе, но вывод нужно обрабатывать вручную (регулярками и т.д.), не имеет идемпотентности, т.е. логику и проверки нужно писать самостоятельно
* Научились создавать группы хостов
* Написали перый `playbook` для клонирования репозитория с помощью команды `git`. Т.к. это не shell, повторный вызов команды не выдает ошибку.

* Ошибка вида `Ошибка 'ascii' codec can't decode byte 0xd0 in position...` - говорит о том,  что в пути к файлу `ansible.cfg` содержатся пробелы или кириллица.
* Если `ansible.cfg` находится в каталоге доступном всем для записи, будет ошибка. Пути решения описаны [тут](https://docs.ansible.com/ansible/devel/reference_appendices/config.html#cfg-in-world-writable-dir), в частности нужно настроить автомонтирование с метадатой в WSL для изменения прав на каталог.

**Задание со***

В [статье](https://medium.com/@Nklya/динамическое-инвентори-в-ansible-9ee880d540d6) описаны варианты получения динамаческого `inventory`:
  * Написание своего скрипта, который должен являться испольняемым файлом и поддерживать определенный интерфейс командной строки.
  * Начиная с `Ansible` версии 2.4. поддерживаются [Inventory Plugins](https://docs.ansible.com/ansible/latest/plugins/inventory.html#inventory-plugins) где данная задача решается декларативным описанием `dynamic inventory` в `yml` файле. [Пример](https://docs.ansible.com/ansible/latest/plugins/inventory/gcp_compute.html) для `GCP`.
