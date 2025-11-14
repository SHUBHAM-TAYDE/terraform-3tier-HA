locals {
  name = "demo"
}

module "vpc" {
  source  = "../../modules/vpc"
  name    = local.name
  region  = var.region
  azs     = ["${var.region}a", "${var.region}b"]
  vpc_cidr = "10.0.0.0/16"
}

module "alb" {
  source = "../../modules/alb"
  name   = local.name

  public_subnet_ids = module.vpc.public_subnet_ids
  vpc_id            = module.vpc.vpc_id
}

# Latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "asg" {
  source = "../../modules/asg_app"
  name   = local.name

  private_subnet_ids = module.vpc.private_subnet_ids
  ami_id             = data.aws_ami.amazon_linux_2.id
  instance_type      = "t3.micro"

  desired           = 1
  min               = 1
  max               = 2
  target_group_arn  = module.alb.target_group_arn
  vpc_id            = module.vpc.vpc_id
}

module "rds" {
  source = "../../modules/rds"
  name   = local.name

  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id             = module.vpc.vpc_id

  db_username = var.db_username
  db_password = var.db_password
}
