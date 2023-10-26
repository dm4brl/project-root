resource "google_compute_backend_service" "dashboard_backend" {
  name     = "dashboard-backend-service"
  protocol = "HTTP"
  
  location = "us-central1"
  
  backend {
    group = google_compute_instance_group.regular_group.self_link
  }
  
  backend {
    group = google_compute_instance_group.custom_group.self_link
  }
  
  health_checks = [google_compute_health_check.http_health_check.self_link]
  
  port = 8080 # Добавьте эту настройку для порта 8080
}
resource "google_compute_url_map" "url_map" {
  name            = "my-url-map"
  default_service = google_compute_backend_service.backend_service.self_link
  
  default_route_action {
    backend_service = google_compute_backend_service.backend_service.self_link
  }
  
  route {
    description = "Dashboard route"
    match {
      prefix = "/dashboard" # Укажите префикс для дашборда
    }
    route_action {
      backend_service = google_compute_backend_service.dashboard_backend.self_link
    }
  }
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
resource "google_project_service" "monitoring" {
  project = var.project_id
  service = "monitoring.googleapis.com"
}

resource "google_project_service" "logging" {
  project = var.project_id
  service = "logging.googleapis.com"
}
