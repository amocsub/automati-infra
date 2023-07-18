terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.1"
    }
  }
}
provider "helm" {
  kubernetes {
    config_path    = var.kubernetes_config_file
    config_context = "gke_${ var.project_id }_${ var.region }_autopilot-primary"
  }
}

provider "kubernetes" {
  config_path    = var.kubernetes_config_file
  config_context = "gke_${ var.project_id }_${ var.region }_autopilot-primary"
}