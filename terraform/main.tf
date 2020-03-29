terraform {
  # Версия terraform
  required_version = "~> 0.12"
}

provider "google" {
  # Версия провайдера
  version = "~> 2.15"

  # ID проекта
  project = var.project #"infra-123456"
  region  = var.region  #"europe-west-1"
}

resource "google_compute_instance" "app" {
  count        = var.instances_qty
  name         = "reddit-app${count.index + 1}"
  machine_type = "g1-small"
  zone         = var.zone #"europe-west1-b"
  tags         = ["reddit-app"]
  boot_disk {
    initialize_params {
      image = var.disk_image #"reddit-base"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    # путь до публичного ключа
    ssh-keys = "appuser:${file(var.public_key_path)}" #"appuser:${file("~/.ssh/appuser.pub")}"
  }

  connection {
    type  = "ssh"
    host  = self.network_interface[0].access_config[0].nat_ip
    user  = "appuser"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key) #file("~/.ssh/appuser")
  }
  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}

resource "google_compute_project_metadata" "ssh_keys" {
  metadata = {
    #ssh-keys = "appuser1:${file(var.public_key_path)}\nappuser2:${file(var.public_key_path)}"
    ssh-keys = join("\n", [for user, key in var.project_ssh_keys : "${user}:${file(key)}"])
  }
}
