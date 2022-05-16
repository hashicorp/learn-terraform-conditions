provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  cidr = var.aws_vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.aws_private_subnet_cidrs
  public_subnets  = var.aws_public_subnet_cidrs

  enable_dns_support = var.enable_dns

  enable_nat_gateway = true
  enable_vpn_gateway = false
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "app" {
  source = "./modules/example-app-deployment"

  aws_instance_count = var.aws_instance_count

  aws_instance_type = var.aws_instance_type
  aws_ami_id        = data.aws_ami.amazon_linux.id
  aws_vpc_id        = module.vpc.vpc_id

  aws_public_subnet_ids  = module.vpc.public_subnets
  aws_private_subnet_ids = module.vpc.private_subnets
}
