provider "aws" {
  region  = "ap-southeast-1" # You can change to your preferred AWS region
  profile = "default"
}

terraform {
  backend "s3" {
    bucket = "qualgo-infrastructure-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

