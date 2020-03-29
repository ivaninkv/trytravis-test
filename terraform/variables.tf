variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable disk_image {
  description = "Disk image"
}
variable "private_key" {
  description = "Private key for ssh connection"
}
variable "zone" {
  default = "europe-west1-b"
}
variable "project_ssh_keys" {
  type = map(string)
}
variable "name" {
  description = "Name for the load balancer forwarding rule and prefix for supporting resources."
  type        = string
  default     = "lb"
}
variable "health_check_port" {
  description = "The TCP port number for the HTTP health check request."
  type        = number
  default     = 9292
}
variable "health_check_path" {
  description = "The request path of the HTTP health check request. The default value is '/'."
  type        = string
  default     = "/"
}
variable "health_check_interval" {
  description = "How often (in seconds) to send a health check. Default is 5."
  type        = number
  default     = 5
}
variable "health_check_healthy_threshold" {
  description = "A so-far unhealthy instance will be marked healthy after this many consecutive successes. The default value is 2."
  type        = number
  default     = 2
}
variable "health_check_unhealthy_threshold" {
  description = "A so-far healthy instance will be marked unhealthy after this many consecutive failures. The default value is 2."
  type        = number
  default     = 2
}
variable "health_check_timeout" {
  description = "How long (in seconds) to wait before claiming failure. The default value is 5 seconds. It is invalid for 'health_check_timeout' to have greater value than 'health_check_interval'"
  type        = number
  default     = 5
}
variable "instances_qty" {
  description = "How many instances VM will be created"
  type        = number
  default     = 1
}
