resource "google_compute_instance" "app" {
  count        = var.instances_qty
  name         = "reddit-app${count.index + 1}"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["reddit-app"]
  boot_disk {
    initialize_params {
      image = var.app_disk_image
    }
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"
  allow {
    protocol = var.puma_protocol
    ports    = var.puma_ports
  }
  source_ranges = var.allow_source_ranges
  target_tags   = ["reddit-app"]
}
