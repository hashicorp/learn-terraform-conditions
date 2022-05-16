# Input variables

variable "aws_vpc_id" {
  description = "ID of the VPC to deploy in."
  type        = string
}

variable "aws_private_subnet_ids" {
  description = "VPC private subnet ids."
  type        = list(string)

  validation {
    condition     = length(var.aws_private_subnet_ids) > 1
    error_message = "This application requires at least two private subnets."
  }
}

variable "aws_public_subnet_ids" {
  description = "VPC public subnet ids."
  type        = list(string)
}

variable "aws_ami_id" {
  description = "EC2 instance AMI ID."
  type        = string
}

variable "aws_instance_count" {
  description = "Number of AWS instances to deploy."
  type        = number

  validation {
    condition     = var.aws_instance_count > 1
    error_message = "This application requires at least two EC2 instances."
  }
}

variable "aws_instance_type" {
  description = "EC2 instance type."
  type        = string
}

