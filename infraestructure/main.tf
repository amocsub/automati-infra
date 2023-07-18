# Service Account & Role Binding
resource "google_service_account" "automati-wip-sa" {
  account_id = "automati-wip-sa"
}

resource "google_service_account_iam_binding" "automati-wip-role-binding" {
  service_account_id = google_service_account.automati-wip-sa.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.automati-wip.name}/attribute.repository_owner/${var.github-org}",
  ]
  depends_on = [google_service_account.automati-wip-sa, google_iam_workload_identity_pool.automati-wip]
}

resource "google_service_account" "automati-k8s-sa" {
  account_id = "automati-k8s-sa"
}

resource "google_service_account_iam_binding" "automati-k8s-role-binding" {
  service_account_id = google_service_account.automati-k8s-sa.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.id.goog[actions-runner-system/automati-k8s-sa]",
  ]
  depends_on = [google_service_account.automati-k8s-sa, google_iam_workload_identity_pool.automati-wip]
}

# GCS Bucket
resource "google_storage_bucket" "automati-bucket" {
  name     = var.bucket_name
  location = var.bucket_location
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "automati-bucket-access-automati-sa" {
  bucket     = google_storage_bucket.automati-bucket.name
  role       = "roles/storage.objectAdmin"
  member     = "serviceAccount:${google_service_account.automati-k8s-sa.email}"
  depends_on = [google_storage_bucket.automati-bucket, google_service_account.automati-k8s-sa]
}

# Workload Identity Pool & Provider
resource "google_iam_workload_identity_pool" "automati-wip" {
  workload_identity_pool_id = "automati-wip"
}

resource "google_iam_workload_identity_pool_provider" "github-enterprise" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.automati-wip.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  display_name                       = "Github"
  description                        = "Github OIDC provider"
  disabled                           = false
  attribute_mapping = {
    "attribute.repository_owner" = "assertion.repository_owner",
    "google.subject"             = "assertion.sub"
  }
  oidc {
    issuer_uri = var.github-oidc-issuer
  }
  depends_on = [google_iam_workload_identity_pool.automati-wip]
}

# Kubernetes Cluster
resource "google_container_cluster" "autopilot-primary" {
  name             = "autopilot-primary"
  location         = var.region
  enable_autopilot = true
  ip_allocation_policy {
  }
}