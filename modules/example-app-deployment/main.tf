# data "aws_ec2_instance_type" "app" {
#   instance_type = var.aws_instance_type
# }

## postcondition example

data "aws_vpc" "app" {
  id = var.aws_vpc_id

  lifecycle {
    postcondition {
      condition     = self.enable_dns_support == true
      error_message = "The selected VPC must have DNS support enabled."      
    }
  }
}

# data "aws_nat_gateway" "vpc" {
#   vpc_id = var.aws_vpc_id
  
#   lifecycle {
#     postcondition {
#       condition     = self.enable_dns_support == true
#       error_message = "The selected VPC must have DNS support enabled."      
#     }
#   }
# }

# data "aws_subnets" "private" {
#   filter {
#     name   = "vpc-id"
#     values = [var.aws_vpc_id]
#   }

#   tags = {
#     Subnet-Type = "Private"
#   }
# }

# data "aws_subnet" "public" {
#   count = length(var.aws_public_subnet_cidrs)

#   vpc_id     = var.aws_vpc_id
#   cidr_block = var.aws_public_subnet_cidrs[count.index]
# }

# data "aws_subnet" "private" {
#   count = length(var.aws_private_subnet_cidrs)

#   vpc_id     = var.aws_vpc_id
#   cidr_block = var.aws_private_subnet_cidrs[count.index]
# }

# data "aws_subnet" "public" {
#   count = length(var.aws_public_subnet_ids)

#   id    = var.aws_public_subnet_ids[count.index]
# }

# module "app_security_group" {
#   source  = "terraform-aws-modules/security-group/aws//modules/web"
#   version = "4.9.0"

#   name        = "app-server-sg"
#   description = "Security group for app servers with HTTP ports open within VPC"
#   vpc_id      = var.aws_vpc_id

#   ingress_cidr_blocks = data.aws_subnet.public.*.cidr_block
# }

# module "lb_security_group" {
#   source  = "terraform-aws-modules/security-group/aws//modules/web"
#   version = "4.9.0"

#   name = "load-balancer-sg"

#   description = "Security group for load balancer with HTTP ports open within VPC"
#   vpc_id      = var.aws_vpc_id

#   ingress_cidr_blocks = ["0.0.0.0/0"]
# }

# resource "random_string" "lb_id" {
#   length  = 8
#   special = false
# }

# module "elb_http" {
#   source  = "terraform-aws-modules/elb/aws"
#   version = "3.0.1"

#   name     = "app-lb-${random_string.lb_id.result}"
#   internal = false

#   security_groups = [module.lb_security_group.security_group_id]
#   subnets         = var.aws_public_subnet_ids

#   number_of_instances = 1
#   instances           = [aws_instance.app.id]

#   listener = [{
#     instance_port     = "80"
#     instance_protocol = "HTTP"
#     lb_port           = "80"
#     lb_protocol       = "HTTP"
#   }]

#   health_check = {
#     target              = "HTTP:80/index.html"
#     interval            = 10
#     healthy_threshold   = 3
#     unhealthy_threshold = 10
#     timeout             = 5
#   }
# }

# resource "aws_instance" "app" {
#   instance_type = var.aws_instance_type
#   ami           = var.aws_ami_id

#   subnet_id              = var.aws_private_subnet_ids[0]
#   vpc_security_group_ids = [module.app_security_group.security_group_id]

#   lifecycle {
#     precondition {
#       condition     = data.aws_ec2_instance_type.app.ebs_optimized_support != "unsupported"
#       error_message = "The EC2 instance type must support EBS optimization."      
#     }
#   }
# }
