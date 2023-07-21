terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.1"
    }
  }
}

provider "kubernetes" {
  config_path    = var.kubernetes_config_file
  config_context = "gke_${var.project_id}_${var.region}_autopilot-primary"
}