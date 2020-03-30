variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1"
}
variable "zone" {
  default = "europe-west1-b"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable "app_disk_image" {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}
variable "db_disk_image" {
  description = "Disk image for reddit app"
  default     = "reddit-db-base"
}
variable "app_source_ranges" {
  default = ["0.0.0.0/0"]
}
variable "ssh_source_ranges" {
  default = ["0.0.0.0/0"]
}
variable "app_machine_type" {
  default = "f1-micro"
}
variable "db_machine_type" {
  default = "f1-micro"
}
