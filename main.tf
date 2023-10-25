provider "google" {
  credentials = file("account.json")
  project     = var.project_name
  region      = var.region
  zone        = var.zone
}

resource "google_compute_instance" "microservice" {
  count        = var.microservice_instance_count
  name         = "microservice-instance-${count.index}"
  machine_type = "n1-standard-2"
  zone         = var.zone

  # Другие настройки для инстанса...

  metadata_startup_script = file("startup-script.sh")
}

resource "google_sql_database_instance" "database" {
  name    = var.database_instance_name
  region  = var.region
  project = var.project_name

  # Другие настройки для базы данных...
}

# И так далее для других ресурсов...

