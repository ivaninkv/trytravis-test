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
  }
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
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
