# Input variables

variable "aws_vpc_id" {
  description = "ID of the VPC to deploy in."
  type        = string
}

variable "aws_private_subnet_ids" {
  description = "VPC private subnet ids."
  type        = list(string)
}

variable "aws_public_subnet_ids" {
  description = "VPC public subnet ids."
  type        = list(string)
}

variable "aws_instance_count" {
  description = "Number of AWS instances to deploy."
  type        = number
}

variable "aws_instance_type" {
  description = "EC2 instance type. Must..."
  type        = string
}

variable "aws_ami_id" {
  description = "EC2 instance AMI ID."
  type        = string
}
