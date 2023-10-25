resource "google_compute_backend_service" "backend_service" {
  name     = "my-backend-service"
  protocol = "HTTP"
  
  # Укажите регион, где будет работать балансировщик
  location = "us-central1"
  
  backend {
    group = google_compute_instance_group.regular_group.self_link
    
    # Добавьте другие настройки бэкенда
  }
  
  backend {
    group = google_compute_instance_group.custom_group.self_link
    
    # Добавьте другие настройки бэкенда
  }

  health_checks = [google_compute_health_check.http_health_check.self_link]

  # Добавьте другие настройки балансировщика
}

resource "google_compute_http_health_check" "http_health_check" {
  name               = "my-http-health-check"
  request_path       = "/healthz"
  check_interval_sec = 5
  timeout_sec        = 5
}

resource "google_compute_url_map" "url_map" {
  name            = "my-url-map"
  default_service = google_compute_backend_service.backend_service.self_link
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name        = "my-http-proxy"
  url_map     = google_compute_url_map.url_map.self_link
  description = "HTTP Proxy for load balancer"
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name       = "my-forwarding-rule"
  target     = google_compute_target_http_proxy.http_proxy.self_link
  port_range = "80"
}

resource "google_compute_firewall" "allow-health-check" {
  name    = "allow-health-check"
  network = "default"
  
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}

resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = "default"
  
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  
  source_ranges = ["0.0.0.0/0"]
}
