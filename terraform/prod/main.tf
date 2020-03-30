terraform {
  required_version = "~> 0.12"
}

provider "google" {
  version = "~> 2.15"
  project = var.project
  region  = var.region
}

module "app" {
  source              = "../modules/app"
  public_key_path     = var.public_key_path
  zone                = var.zone
  app_disk_image      = var.app_disk_image
  machine_type        = var.app_machine_type
  allow_source_ranges = var.app_source_ranges
}

module "db" {
  source          = "../modules/db"
  public_key_path = var.public_key_path
  zone            = var.zone
  db_disk_image   = var.db_disk_image
  machine_type    = var.db_machine_type
}

module "vpc" {
  source        = "../modules/vpc"
  protocol      = "tcp"
  ports         = ["22"]
  source_ranges = var.ssh_source_ranges
}
