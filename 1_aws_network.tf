data "aws_availability_zones" "available" {
  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ec2_instance_type_offerings" "supported" {
  location_type = "availability-zone"

  filter {
    name   = "instance-type"
    values = [var.az_filter_instance_type]
  }
}

locals {
  candidate_azs = [
    for az in data.aws_availability_zones.available.names : az
    if contains(data.aws_ec2_instance_type_offerings.supported.locations, az)
  ]

  sorted_candidate_azs = sort(local.candidate_azs)
  selected_azs         = length(local.sorted_candidate_azs) > 0 ? local.sorted_candidate_azs : data.aws_availability_zones.available.names
  azs                  = slice(local.selected_azs, 0, min(length(local.selected_azs), 3))
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = [for idx, az in local.azs : cidrsubnet(var.vpc_cidr, 4, idx)]
  public_subnets  = [for idx, az in local.azs : cidrsubnet(var.vpc_cidr, 8, idx + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = {
    Blueprint = var.vpc_name
  }
}
