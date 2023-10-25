provider "google" {
  credentials = file("your-gcp-credentials.json")  # Путь к вашему файлу учетных данных GCP
  project     = "your-gcp-project"               # Имя вашего проекта GCP
  region      = "us-central1"                    # Регион GCP
}

resource "google_container_cluster" "kafka_cluster" {
  name     = "kafka-cluster"
  location = "us-central1"
  initial_node_count = 3
  # Другие настройки кластера GKE по вашему усмотрению
}

provider "kubernetes" {
  config_path = "~/.kube/config"  # Путь к вашему kubeconfig файлу
}

resource "kubernetes_namespace" "kafka_namespace" {
  metadata {
    name = "kafka"
  }
}

resource "helm_release" "kafka" {
  name       = "kafka"
  repository = "https://charts.confluent.io"
  chart      = "confluent-kafka"
  namespace  = kubernetes_namespace.kafka_namespace.metadata[0].name

  set {
    name  = "cp-schema-registry.enabled"
    value = "false"
  }
  # Другие параметры Helm Chart для Kafka
}
