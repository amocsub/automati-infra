# Kubernetes Cluster
resource "google_container_cluster" "autopilot-primary" {
  name             = "autopilot-primary"
  location         = var.region
  project          = var.project_id
  enable_autopilot = true
  ip_allocation_policy {
  }
}