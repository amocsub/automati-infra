######################################################################
## Setup 
######################################################################

variable "kubernetes_config_file" {
  default     = "~/.kube/config"
  description = "Kubernetes config file path"
}

variable "project_id" {
  # default     = "PUT-HERE-YOUR-GCP-PROJECT-ID"
  description = "GCP project ID where the infrastructure was created"
}

variable "region" {
  # default     = "PUT-HERE-YOUR-GCP-REGION"
  description = "GCP region where the infrastructure was created"
}

######################################################################
## Github related data
######################################################################

variable "repository_name_with_owner" {
  # default     = "PUT-HERE-YOUR-GITHUB-REPO"
  description = "This should be the owner/repository_name from the repo you want to associate the runners to"
}

######################################################################
## Runner resource definitions
######################################################################

variable "req_runner_cpu" {
  default     = "1"
  description = "This is the maximum CPU that can be allocated for a runner"
}

variable "req_runner_memory" {
  default     = "2Gi"
  description = "This is the maximum memory that can be allocated for a runner"
}

variable "req_runner_ephemeral_disk" {
  default     = "1Gi"
  description = "This is the maximum ephemeral disk that can be allocated for a runner, autopilot have a maximum of 10Gi"
}

variable "min_replicas" {
  default     = 1
  description = "Minimum amount of replicas to keep always up, can also be set up to 0"
}

variable "max_replicas" {
  default     = 256
  description = "Maximum amount of replicas to keep always up, please consider that the max of simultaneous jobs could be 256 per matrix, so keep it to 256 maximum"
}

variable "teardown_time" {
  default     = "10m"
  description = "Maximum time to wait until a new job to shoutdown the inactive pod"
}