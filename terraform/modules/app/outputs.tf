output "app_external_ip" {
  description = "The external ip address of the app"
  value       = "${google_compute_instance.app[*].network_interface[0].access_config[0].nat_ip}"
}
