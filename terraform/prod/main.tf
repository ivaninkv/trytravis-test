terraform {
  required_version = "~> 0.12"
}

provider "google" {
  version = "~> 2.15"
  project = var.project
  region  = var.region
}

resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = "f1-micro"
  zone         = var.zone
  #tags         = ["reddit-app"]
  boot_disk {
    initialize_params {
      image = "ubuntu-1604-lts"
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}


module "app" {
  source              = "../modules/app"
  public_key_path     = var.public_key_path
  private_key_path    = var.private_key_path
  zone                = var.zone
  app_disk_image      = var.app_disk_image
  machine_type        = var.app_machine_type
  allow_source_ranges = var.app_source_ranges
  db_url              = module.db.db_private_ip
}

module "db" {
  source           = "../modules/db"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  zone             = var.zone
  db_disk_image    = var.db_disk_image
  machine_type     = var.db_machine_type
  bastion_ip       = "${google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip}"
}

module "vpc" {
  source        = "../modules/vpc"
  protocol      = "tcp"
  ports         = ["22"]
  source_ranges = var.ssh_source_ranges
}
