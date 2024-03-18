variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"

  # france 
  #default     = "eu-west-3"

  # spain 
  #default    = "eu-south-2"
}


variable "product" {
  type        = string
  default     = "hex7"
}


variable "lambda_runtime" {
  type        = string
  default     = "python3.12"
}


variable "lambda_version" {
  type        = string
  default     = "1"
}


variable "tags" {
  type        = map(any)
  default     = { 
                  Product = "Hex7"
                  Owner   = "Hex7"
                }
}
