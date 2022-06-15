provider "aws" {
    region = "us-east-1"
}

variable "project-name" {
  type = string
  default = "project-name-default-name"
}

variable "vpc-id" {
  type = string
}