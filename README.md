# terraform-aws-betternat

AWS Terraform module for BetterNAT.

This module is the user-facing AWS install surface. It wraps the
`nowakeai/betternat` provider's `betternat_aws_gateway` resource and maps common
VPC module outputs into one BetterNAT gateway group per AZ.

## Usage

```hcl
module "betternat" {
  source  = "nowakeai/betternat/aws"
  version = "~> 0.2"

  name   = "prod-egress"
  vpc_id = module.vpc.vpc_id

  azs                     = module.vpc.azs
  public_subnet_ids       = module.vpc.public_subnets
  private_route_table_ids = module.vpc.private_route_table_ids

  private_cidrs = [module.vpc.vpc_cidr_block]
}
```

For production, keep the public identity independent from the gateway
lifecycle:

```hcl
resource "aws_eip" "betternat" {
  for_each = toset(module.vpc.azs)
  domain   = "vpc"

  lifecycle {
    prevent_destroy = true
  }
}

module "betternat" {
  source  = "nowakeai/betternat/aws"
  version = "~> 0.2"

  # ...
  eip_allocation_ids = {
    for az, eip in aws_eip.betternat : az => eip.id
  }
}
```

The module passes each allocation ID only to the matching per-AZ gateway.
BetterNAT associates and observes externally managed EIPs but never releases
them. For an existing provider-managed deployment, first set
`retain_managed_eips_on_destroy = true` and apply before replacement; use that
option as a migration fallback rather than the preferred ownership model.

The module defaults to:

- latest AL2023 arm64 AMI lookup,
- `t4g.small`,
- Spot instances enabled,
- active/standby capacity per AZ,
- stable shared EIP mode,
- automatic primary and SNAT interface detection,
- cloud-init bootstrap with BetterNAT runtime `v0.2.0`,
- rollback on destroy.

Run BetterNAT in a disposable VPC before replacing a production NAT Gateway.

## When To Use This Module

Use this module when private AWS workloads have enough NAT Gateway processing
traffic to justify a self-managed active/standby gateway group.

Start with the BetterNAT user docs:

- Quick Start: <https://github.com/nowakeai/betternat/blob/main/docs/user/getting-started/QUICK_START.md>
- Limitations: <https://github.com/nowakeai/betternat/blob/main/docs/user/reference/LIMITATIONS.md>
- Operations: <https://github.com/nowakeai/betternat/blob/main/docs/user/operations/OPERATIONS_GUIDE.md>
- Rollback: <https://github.com/nowakeai/betternat/blob/main/docs/user/operations/ROLLBACK_GUIDE.md>

## Route Ownership

BetterNAT owns the private default routes for the route tables passed to this
module. Do not keep separate `aws_route` resources managing the same
`0.0.0.0/0` route while BetterNAT is active.

## Validation

```sh
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

Before the matching BetterNAT provider `0.2.0` is published, maintainers can
run `init` and `validate` with a local provider filesystem mirror. After
publication, the normal Terraform Registry install path should pass `init` and
`validate` without a mirror.
