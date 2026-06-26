terraform {
  required_version = ">= 1.6.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.77.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "betternat-full-vpc-smoke"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.77.0.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

module "betternat" {
  source = "../.."

  name   = "smoke-egress"
  vpc_id = aws_vpc.main.id

  azs                     = ["us-west-2a"]
  public_subnet_ids       = [aws_subnet.public.id]
  private_route_table_ids = [aws_route_table.private.id]
  private_cidrs           = [aws_vpc.main.cidr_block]
}
