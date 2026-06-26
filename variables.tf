variable "name" {
  type        = string
  description = "Base name for BetterNAT gateway resources."
}

variable "region" {
  type        = string
  description = "AWS region. Defaults to the current AWS provider region."
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "Target VPC ID."
}

variable "azs" {
  type        = list(string)
  description = "Availability zones matching public_subnet_ids and private_route_table_ids by index."

  validation {
    condition     = length(var.azs) > 0
    error_message = "azs must contain at least one availability zone."
  }
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs matching azs by index. This accepts terraform-aws-modules/vpc/aws public_subnets output."
}

variable "private_route_table_ids" {
  type        = list(string)
  description = "Private route table IDs matching azs by index. This accepts terraform-aws-modules/vpc/aws private_route_table_ids output."
}

variable "private_cidrs" {
  type        = list(string)
  description = "Private CIDRs allowed to use BetterNAT for SNAT."
}

variable "ami_id" {
  type        = string
  description = "Explicit Linux AMI ID for gateway nodes. When null, the module looks up the latest AL2023 arm64 AMI."
  default     = null
}

variable "ami_name_pattern" {
  type        = string
  description = "AMI name pattern used when ami_id is null."
  default     = "al2023-ami-2023.*-arm64"
}

variable "instance_type" {
  type        = string
  description = "Gateway node instance type."
  default     = "t4g.small"
}

variable "use_spot" {
  type        = bool
  description = "Use Spot instances for gateway nodes."
  default     = true
}

variable "min_size" {
  type        = number
  description = "Auto Scaling Group minimum size per AZ gateway group."
  default     = 1
}

variable "desired_capacity" {
  type        = number
  description = "Auto Scaling Group desired capacity per AZ gateway group."
  default     = 2
}

variable "max_size" {
  type        = number
  description = "Auto Scaling Group maximum size per AZ gateway group."
  default     = 3
}

variable "betternat_version" {
  type        = string
  description = "BetterNAT runtime release tag."
  default     = "v0.1.0"
}

variable "bootstrap_mode" {
  type        = string
  description = "Gateway node bootstrap mode."
  default     = "cloud_init"
}

variable "stable_egress_ip" {
  type        = bool
  description = "Manage a shared EIP for stable egress identity."
  default     = true
}

variable "ha_profile" {
  type        = string
  description = "BetterNAT HA timing profile."
  default     = "default"
}

variable "prometheus_enabled" {
  type        = bool
  description = "Expose Prometheus metrics from gateway nodes."
  default     = true
}

variable "rollback_on_destroy" {
  type        = bool
  description = "Restore captured private route targets during destroy."
  default     = true
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Advanced override for launch-template public IPv4 behavior."
  default     = null
}

variable "agent_binary_url" {
  type        = string
  description = "Advanced test-only override for the betternat-agent binary URL."
  default     = null
  sensitive   = true
}

variable "agent_binary_sha256" {
  type        = string
  description = "Advanced test-only override for the betternat-agent binary SHA256."
  default     = null
}

variable "cli_binary_url" {
  type        = string
  description = "Advanced test-only override for the betternat CLI binary URL."
  default     = null
  sensitive   = true
}

variable "cli_binary_sha256" {
  type        = string
  description = "Advanced test-only override for the betternat CLI binary SHA256."
  default     = null
}

variable "loxicmd_binary_url" {
  type        = string
  description = "Advanced override for a host loxicmd binary URL."
  default     = null
  sensitive   = true
}

variable "loxicmd_binary_sha256" {
  type        = string
  description = "Advanced override for loxicmd_binary_url SHA256."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to provider-managed AWS resources."
  default     = {}
}
