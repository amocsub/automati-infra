################################################################################################################################################################################################################
## Setup
################################################################################################################################################################################################################
variable "project_id" {
  description = "GCP project ID where to create the infraestructure"
}

variable "region" {
  description = "GCP region where to create the infraestructure"
}

################################################################################################################################################################################################################
## GitHub related data
################################################################################################################################################################################################################

variable "github_oidc_issuer" {
  default     = "https://token.actions.githubusercontent.com"
  description = "Github Host that would be able to authenticate to GCP, taken from https://token.actions.githubusercontent.com/.well-known/openid-configuration, it could also auth with a github enterprise server if needed."
}

variable "github_org" {
  description = "Github Organization allowed to interact to the GCP project, in case you fork this repo your username would be the github_org, in my case 'amocsub'"
}

################################################################################################################################################################################################################
## Bucket data
################################################################################################################################################################################################################

variable "bucket_name" {
  description = "Bucket name to be used to store artifact between job runs"
}

variable "bucket_location" {
  description = "Location of your GCS bucket"
}