variable "ports" {
  default = ["22"]
}
variable "protocol" {
  default = "tcp"
}
variable "source_ranges" {
  default = ["0.0.0.0/0"]
}
