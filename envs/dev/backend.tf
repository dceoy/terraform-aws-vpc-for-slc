terraform {
  backend "s3" {
    bucket         = var.tfstate_s3_bucket
    key            = var.tfstate_s3_key
    region         = var.region
    encrypt        = true
    dynamodb_table = var.tfstate_dynamodb_table
  }
}
