output "db_private_ip" {
  description = "The private ip address of the db"
  value       = "${join("", google_compute_instance.db[*].network_interface[0].network_ip)}"
}

output "db_external_ip" {
  description = "The external ip address of the db"
  value       = "${join("", google_compute_instance.db[*].network_interface[0].access_config[0].nat_ip)}"
}
