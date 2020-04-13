resource "google_compute_instance" "db" {
  count        = var.instances_qty
  name         = "reddit-db${count.index + 1}"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["reddit-db"]
  boot_disk {
    initialize_params {
      image = var.db_disk_image
    }
  }
  network_interface {
    network = "default"
    access_config {} # нужен внешний IP для ДЗ по ansible
  }
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
  connection {
    type        = "ssh"
    host        = self.network_interface[0].network_ip
    user        = "appuser"
    private_key = file(var.private_key_path)
    agent       = "false"
    timeout     = "1m"

    bastion_host        = var.bastion_ip
    bastion_private_key = file(var.private_key_path)
  }
  provisioner "remote-exec" {
    script = "${path.module}/files/mongo_bindip.sh"
  }
}

resource "google_compute_firewall" "firewall_mongo" {
  name    = "allow-mongo-default"
  network = "default"
  allow {
    protocol = var.mongo_protocol
    ports    = var.mongo_ports
  }
  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
}
