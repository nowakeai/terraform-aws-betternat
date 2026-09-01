data "aws_region" "current" {}

data "aws_ami" "al2023_arm64" {
  count       = var.ami_id == null ? 1 : 0
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  region          = coalesce(var.region, data.aws_region.current.region)
  selected_ami_id = coalesce(var.ami_id, one(data.aws_ami.al2023_arm64[*].id))

  az_configs = {
    for idx, az in var.azs : az => {
      public_subnet_id        = var.public_subnet_ids[idx]
      private_route_table_ids = [var.private_route_table_ids[idx]]
    }
  }
}

check "external_eip_configuration" {
  assert {
    condition     = length(var.eip_allocation_ids) == 0 || var.stable_egress_ip
    error_message = "eip_allocation_ids requires stable_egress_ip = true."
  }

  assert {
    condition     = alltrue([for az in keys(var.eip_allocation_ids) : contains(var.azs, az)])
    error_message = "Every eip_allocation_ids key must also be present in azs."
  }
}

resource "betternat_aws_gateway" "this" {
  for_each = local.az_configs

  name   = length(var.azs) == 1 ? var.name : "${var.name}-${each.key}"
  region = local.region
  vpc_id = var.vpc_id

  public_subnet_ids = {
    (each.key) = each.value.public_subnet_id
  }

  private_route_table_ids = {
    (each.key) = each.value.private_route_table_ids
  }

  private_cidrs = var.private_cidrs

  ami_id            = local.selected_ami_id
  instance_type     = var.instance_type
  use_spot          = var.use_spot
  min_size          = var.min_size
  desired_capacity  = var.desired_capacity
  max_size          = var.max_size
  betternat_version = var.betternat_version
  bootstrap_mode    = var.bootstrap_mode
  stable_egress_ip  = var.stable_egress_ip
  eip_allocation_ids = {
    for az, allocation_id in var.eip_allocation_ids : az => allocation_id
    if az == each.key
  }
  retain_managed_eips_on_destroy = var.retain_managed_eips_on_destroy
  primary_interface              = var.primary_interface
  snat_interface                 = var.snat_interface
  ha_profile                     = var.ha_profile
  prometheus_enabled             = var.prometheus_enabled
  rollback_on_destroy            = var.rollback_on_destroy

  associate_public_ip_address = var.associate_public_ip_address
  agent_binary_url            = var.agent_binary_url
  agent_binary_sha256         = var.agent_binary_sha256
  cli_binary_url              = var.cli_binary_url
  cli_binary_sha256           = var.cli_binary_sha256
  loxicmd_binary_url          = var.loxicmd_binary_url
  loxicmd_binary_sha256       = var.loxicmd_binary_sha256

  tags = var.tags
}
