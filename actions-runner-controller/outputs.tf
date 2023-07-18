output "get-cluster-credentials" {
  value       = "gcloud compute forwarding-rules list --region ${var.region} --project ${var.project}"
  description = "Run this command to get the load balancer public IP-ADDRESS to be seted up at the webhook"
}

