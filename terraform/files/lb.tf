# module "lb" {
#   # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
#   # to a specific version of the modules, such as the following example:
#   source               = "github.com/gruntwork-io/terraform-google-load-balancer.git//modules/network-load-balancer?ref=v0.2.2"
#   name                 = "lb-forwarding-rule"
#   region               = var.region
#   project              = var.project
#   enable_health_check  = true
#   health_check_port    = "9292"
#   health_check_path    = "/"
#   firewall_target_tags = ["reddit-app"]
#   instances            = [google_compute_instance.app.self_link]
#   #custom_labels        = var.custom_labels
# }

# ------------------------------------------------------------------------------
# CREATE FORWARDING RULE
# ------------------------------------------------------------------------------

resource "google_compute_forwarding_rule" "default" {
  #provider              = google-beta
  project               = var.project
  name                  = var.name
  target                = google_compute_target_pool.default.self_link
  load_balancing_scheme = "EXTERNAL"
  #port_range            = var.port_range
  #ip_address            = var.ip_address
  #ip_protocol           = var.protocol
  region = var.region

  #labels = var.custom_labels
}

# ------------------------------------------------------------------------------
# CREATE TARGET POOL
# ------------------------------------------------------------------------------

resource "google_compute_target_pool" "default" {
  provider = google-beta
  project  = var.project
  name     = "${var.name}-tp"
  region   = var.region
  #session_affinity = var.session_affinity

  instances = google_compute_instance.app.*.self_link

  health_checks = google_compute_http_health_check.default.*.name
}

# ------------------------------------------------------------------------------
# CREATE HEALTH CHECK
# ------------------------------------------------------------------------------

resource "google_compute_http_health_check" "default" {
  #count = var.enable_health_check ? 1 : 0

  provider            = google-beta
  project             = var.project
  name                = "${var.name}-hc"
  request_path        = var.health_check_path
  port                = var.health_check_port
  check_interval_sec  = var.health_check_interval
  healthy_threshold   = var.health_check_healthy_threshold
  unhealthy_threshold = var.health_check_unhealthy_threshold
  timeout_sec         = var.health_check_timeout
}


# ------------------------------------------------------------------------------
# CREATE FIREWALL FOR THE HEALTH CHECKS
# ------------------------------------------------------------------------------

# Health check firewall allows ingress tcp traffic from the health check IP addresses
resource "google_compute_firewall" "health_check" {
  #count = var.enable_health_check ? 1 : 0

  provider = google-beta
  project  = var.project
  name     = "${var.name}-hc-fw"
  network  = "default"

  allow {
    protocol = "tcp"
    ports    = [var.health_check_port]
  }

  # These IP ranges are required for health checks
  #source_ranges = ["209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16"]

  # Target tags define the instances to which the rule applies
  target_tags = ["reddit-app"]
}
