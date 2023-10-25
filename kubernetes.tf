resource "google_container_cluster" "example_cluster" {
  name     = "my-cluster"
  location = "us-central1"

  master_auth {
    username = ""
    password = ""
  }
}

resource "google_container_node_pool" "example_node_pool" {
  name       = "my-node-pool"
  location   = google_container_cluster.example_cluster.location
  cluster    = google_container_cluster.example_cluster.name
  node_count = 2

  node_config {
    preemptible  = false
    machine_type = "n1-standard-2"
    disk_size_gb = 100

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

resource "google_service_networking_connection" "example_connection" {
  network    = "default"
  service    = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["servicenetworking.googleapis.com"]
}
