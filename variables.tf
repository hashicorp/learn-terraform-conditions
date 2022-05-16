# Input variables

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "aws_vpc_cidr" {
  description = "CIDR block for VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_private_subnet_cidrs" {
  description = "CIDR blocks for VPC private subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "aws_public_subnet_cidrs" {
  description = "CIDR blocks for VPC public subnets."
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "enable_dns" {
  description = "Enable DNS support in VPC."
  type        = bool
}

variable "aws_instance_count" {
  description = "Number of AWS instances to deploy."
  type        = number
}

variable "aws_instance_type" {
  description = "EC2 instance type."
  type        = string
}
