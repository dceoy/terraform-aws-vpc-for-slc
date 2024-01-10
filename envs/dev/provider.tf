variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "AWS profile"
  type        = string
  default     = "default"
}

provider "aws" {
  region  = var.region
  profile = var.profile
}
