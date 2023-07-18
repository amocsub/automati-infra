variable "project_id" {
  # default     = ""
  description = "GCP project ID where to create the infraestructure"
}

variable "region" {
  # default     = ""
  description = "GCP region where to create the infraestructure"
}

variable "github-oidc-issuer" {
  default     = "https://token.actions.githubusercontent.com"
  description = "Github Host that would be able to authenticate to GCP, taken from https://token.actions.githubusercontent.com/.well-known/openid-configuration, it could also auth with a github enterprise server if needed."
}

variable "github-org" {
  # default     = ""
  description = "Github Organization allowed to interact to the GCP project, in case you fork this repo your username would be the github-org, in my case 'amocsub'"
}

variable "bucket_name" {
  # default = ""
  description = "Bucket name to be used to store artifact between jobs, should be unique"
}

variable "bucket_location" {
  default = "EU"
  description = "Location of your GCS bucket"
  
}