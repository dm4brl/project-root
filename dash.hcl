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
resource "google_monitoring_uptime_check_config" "dashboard_check" {
  display_name = "Dashboard Uptime Check"
  monitored_resource_types = ["gce_instance"]
  http_check {
    use_ssl = false
    path = "/dashboard" # Путь к вашему дашборду
    port = 8080 # Порт, на котором работает дашборд
    request_method = "GET"
    validate_ssl = false
  }
  timeout = "5s"
  period = "60s"
  project = var.project_id
}

resource "google_monitoring_notification_channel" "email_channel" {
  display_name = "Email Channel"
  type         = "email"
  labels = {
    email_address = "your@email.com"
  }
}

resource "google_monitoring_alert_policy" "dashboard_alert" {
  display_name = "Dashboard Alert Policy"
  conditions {
    display_name = "Dashboard is down"
    display_name = "Dashboard is down"
    condition_threshold {
      filter             = 'metric.type="monitoring.googleapis.com/uptime_check/downtime"'
      comparison_type    = "COMPARISON_TYPE_UNSPECIFIED"
      aggregations {
        alignment_period  = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
      threshold_value    = 1.0
      duration           = "60s"
      aggregations {
        alignment_period  = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
      comparison_type    = "COMPARISON_TYPE_UNSPECIFIED"
      aggregations {
        alignment_period  = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
  notification_channels = [google_monitoring_notification_channel.email_channel.name]
}
