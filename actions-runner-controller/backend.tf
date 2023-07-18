# In case you want to store the terraform files in a GCP bucket un-comment the below and specify your bucket name. Be sure to have access to that bucket from where you are going to be triggering terraform
# terraform {
#   backend "gcs" {
#     bucket = "YOUR-BUCKET-NAME"
#     prefix = "arc"
#   }
# }