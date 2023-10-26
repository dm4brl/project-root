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
