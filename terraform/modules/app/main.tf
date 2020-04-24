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
  connection {
    type        = "ssh"
    host        = self.network_interface[0].access_config[0].nat_ip
    user        = "appuser"
    private_key = file(var.private_key_path)
    agent       = "false"
    timeout     = "1m"
  }
  # provisioner "file" {
  #   source      = "${path.module}/files/puma.service"
  #   destination = "/tmp/puma.service"
  # }
  # provisioner "remote-exec" {
  #   inline = ["sed -i s/db_private_ip/${var.db_url}/ /tmp/puma.service"]
  # }
  # provisioner "remote-exec" {
  #   script = "${path.module}/files/deploy.sh"
  # }
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

resource "google_compute_firewall" "firewall_http" {
  name    = "allow-http"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = var.allow_source_ranges
  target_tags   = ["reddit-app"]
}
