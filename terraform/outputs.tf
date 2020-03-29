output "app_external_ip" {
  description = "The external ip address of the app"
  value       = google_compute_instance.app.network_interface[0].access_config[0].nat_ip
}

# output "load_balancer_default_ip" {
#   description = "The external ip address of the forwarding rule for default lb."
#   value       = module.load_balancer_default.external_ip
# }
