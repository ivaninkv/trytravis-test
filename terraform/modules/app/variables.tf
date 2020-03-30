variable "instances_qty" {
  description = "How many instances VM will be created"
  type        = number
  default     = 1
}
variable "zone" {
  default = "europe-west1-b"
}
variable "app_disk_image" {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}
variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable "machine_type" {
  default = "g1-small"
}
variable "puma_protocol" {
  default = "tcp"
}
variable "puma_ports" {
  default = ["9292"]
}
variable "allow_source_ranges" {
  description = "Allow source ranges IP address"
}
