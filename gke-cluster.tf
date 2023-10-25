provider "google" {
  credentials = file("path/to/your-service-account-key.json")
  project     = "your-gcp-project-id"
  region      = "us-central1"
}

resource "google_container_cluster" "example" {
  name     = "example-cluster"
  location = "us-central1"

  initial_node_count = 1

  master_auth {
    username = ""
    password = ""
  }
}

resource "google_container_node_pool" "example" {
  name       = "example-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.example.name
  node_count = 1

  node_config {
    preemptible  = false
    machine_type = "n1-standard-1"
  }
}
