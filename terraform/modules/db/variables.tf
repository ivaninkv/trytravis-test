variable "instances_qty" {
  description = "How many instances VM will be created"
  type        = number
  default     = 1
}
variable "zone" {
  default = "europe-west1-b"
}
variable "db_disk_image" {
  description = "Disk image for reddit app"
  default     = "reddit-db-base"
}
variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable "private_key_path" {
  description = "Path to the private key used for ssh access"
}
variable "machine_type" {
  default = "g1-small"
}
variable "mongo_protocol" {
  default = "tcp"
}
variable "mongo_ports" {
  default = ["27017"]
}
variable "bastion_ip" {
  description = "IP address of bastion host"
}
