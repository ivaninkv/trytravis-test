output "db_private_ip" {
  description = "The private ip address of the db"
  value       = "${join("", google_compute_instance.db[*].network_interface[0].network_ip)}"
}
