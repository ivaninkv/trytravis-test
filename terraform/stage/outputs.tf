output "app_external_ip" {
  description = "The external ip address of the app"
  #value       = "${google_compute_instance.app[*].network_interface[0].access_config[0].nat_ip}"
  value = module.app.app_external_ip
}

output "db_private_ip" {
  description = "The private ip address of the db"
  value       = module.db.db_private_ip
}

output "bastion_ip" {
  description = "The bastion ip address"
  value       = "${google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip}"
}

# ["${aws_s3_bucket.s3_bucket.*.bucket}"]
# output "load_balancer_default_ip" {
#   description = "The external ip address of the forwarding rule for default lb."
#   value       = module.load_balancer_default.external_ip
# }

# output "load_balancer_ip_address" {
#   description = "Internal IP address of the load balancer"
#   value       = google_compute_forwarding_rule.default.ip_address
# }
