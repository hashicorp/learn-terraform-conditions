data "aws_subnet" "public" {
  count = length(var.aws_public_subnet_ids)

  id = var.aws_public_subnet_ids[count.index]
}

module "app_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "4.9.0"

  name        = "app-server-sg"
  description = "Security group for app servers with HTTP ports open within VPC"
  vpc_id      = var.aws_vpc_id

  ingress_cidr_blocks = data.aws_subnet.public.*.cidr_block
}

module "lb_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "4.9.0"

  name = "load-balancer-sg"

  description = "Security group for load balancer with HTTP ports open within VPC"
  vpc_id      = var.aws_vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

resource "random_string" "lb_id" {
  length  = 8
  special = false
}

module "elb_http" {
  source  = "terraform-aws-modules/elb/aws"
  version = "3.0.1"

  name     = "app-lb-${random_string.lb_id.result}"
  internal = false

  security_groups = [module.lb_security_group.security_group_id]
  subnets         = var.aws_public_subnet_ids

  number_of_instances = length(aws_instance.app)
  instances           = aws_instance.app.*.id

  listener = [{
    instance_port     = "80"
    instance_protocol = "HTTP"
    lb_port           = "80"
    lb_protocol       = "HTTP"
  }]

  health_check = {
    target              = "HTTP:80/index.html"
    interval            = 10
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
  }
}

resource "aws_instance" "app" {
  count = var.aws_instance_count

  instance_type = var.aws_instance_type
  ami           = var.aws_ami_id

  subnet_id              = var.aws_private_subnet_ids[count.index % length(var.aws_private_subnet_ids)]
  vpc_security_group_ids = [module.app_security_group.security_group_id]
}
