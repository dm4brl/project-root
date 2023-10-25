resource "google_compute_routes" "example_routes" {
  name = "my-routes"

  # Укажите сеть, для которой настраиваются маршруты
  network = google_compute_network.example_network.name

  route {
    name                  = "route-1"
    description           = "Route 1"
    dest_range            = "10.0.0.0/24" # Целевая подсеть
    priority              = 1000
    next_hop_gateway      = "default-internet-gateway" # Имя шлюза
  }

  route {
    name                  = "route-2"
    description           = "Route 2"
    dest_range            = "10.0.1.0/24" # Другая целевая подсеть
    priority              = 1001
    next_hop_instance     = google_compute_instance.example_instance.self_link
  }
}
