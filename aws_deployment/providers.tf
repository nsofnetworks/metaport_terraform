terraform {
  required_providers {
    metanetworks = {
      source = "github.com/metanetworks/metanetworks"
      version = "1.0.12"
    }
  }
}

provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.profile
}

provider "cloudinit" {}