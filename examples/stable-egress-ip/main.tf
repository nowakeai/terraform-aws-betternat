terraform {
  required_version = ">= 1.6.0"
}

provider "aws" {
  region = "us-west-2"
}

module "betternat" {
  source = "../.."

  name   = "stable-egress"
  vpc_id = "vpc-0123456789abcdef0"

  azs                     = ["us-west-2a"]
  public_subnet_ids       = ["subnet-public-a"]
  private_route_table_ids = ["rtb-private-a"]
  private_cidrs           = ["10.0.0.0/16"]

  stable_egress_ip = true
}
