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
## GitHub related data
######################################################################

variable "github_app_id" {
  # default     = "PUT-HERE-YOUR-GITHUB-APP-ID"
  description = "The ID of your GitHub App. From the following url you would find it out if you installed the app with the name automati. https://github.com/settings/apps/automati-app"
}

variable "github_app_installation_id" {
  # default     = "PUT-HERE-YOUR-GITHUB-APP-INSTALLATION-ID
  description = "The ID of your GitHub App installation. Once you have your app installed at https://github.com/settings/installations if you go to your app the id would be the last path in the URL"
}

variable "github_app_private_key" {
  # default     = "PUT-HERE-YOUR-GITHUB-APP-PRIVATE-KEY-PATH"
  description = "GitHub App's private key file path. You can generate it from https://github.com/settings/apps/automati-app clicking on 'Generate a private key' button "
}

variable "enable_github_webhook_server" {
  default     = true
  description = "Github Webhook Server is what grants you the cappability of automatically scalling the cluster on demand when there is a new job, the scaler can decrease to 0 if there are no jobs"
}

variable "github_webhook_secret_token" {
  # default     = "PUT-HERE-YOUR-WEBHOOK-SECRET-TOKEN"
  description = "GitHub WebHook Secret Token. You can generate it with https://passwordsgenerator.net/ and it's going to be used for the webhooks"
}

######################################################################
## Runner resource definitions
######################################################################

variable "runner_docker_image" {
  default     = "buscoma/automati-runner:ubuntu-20.04"
  description = "Image to be used by the runner pods to be deployed, you might have to change it in case you want to extend the image with tools I do not cover here"
}

variable "max_runner_cpu" {
  default     = "2"
  description = "This is the maximum CPU that can be allocated for a runner"
}

variable "max_runner_memory" {
  default     = "4Gi"
  description = "This is the maximum memory that can be allocated for a runner"
}

variable "max_runner_ephemeral_disk" {
  default     = "2Gi"
  description = "This is the maximum ephemeral disk that can be allocated for a runner, autopilot have a maximum of 10Gi"
}