variable "bucket" {
  type    = string
  default = "hex7.com"
}


variable "aws_region" {
  type    = string
  default = "us-east-1"
}


variable "aws_profile" {
  type    = string
  default = "default"
}


variable "product" {
  type    = string
  default = "hex7"
}


variable "tags" {
  type    = map
  default = {   
    Name  = "hex7.com"
  }
}
