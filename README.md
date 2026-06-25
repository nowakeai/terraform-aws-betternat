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

The module defaults to:

- latest AL2023 arm64 AMI lookup,
- `t4g.small`,
- Spot instances enabled,
- active/standby capacity per AZ,
- stable shared EIP mode,
- cloud-init bootstrap with BetterNAT runtime `v0.1.0`,
- rollback on destroy.

Run BetterNAT in a disposable VPC before replacing a production NAT Gateway.

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
