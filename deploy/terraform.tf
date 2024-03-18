provider "aws" {
  region  = var.aws_region

  default_tags {
    tags = {
      owner = "hex7"
      product = "hex7"
    }
  }
}

terraform {
  backend "s3" {
    bucket  = "hex7.com"
    key     = "hex7.tfstate"
    region  = "us-east-1"
    encrypt = false
  }
}
