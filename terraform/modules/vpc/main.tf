resource "google_compute_firewall" "firewall_ssh" {
  description = "Default ssh rule"
  name        = "default-allow-ssh"
  network     = "default"
  allow {
    protocol = var.protocol
    ports    = var.ports
  }
  source_ranges = var.source_ranges
}
