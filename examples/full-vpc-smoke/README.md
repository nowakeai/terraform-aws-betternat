# Full VPC Smoke Example

This is a disposable validation example for the AWS BetterNAT module. It is not
a reusable Terraform submodule.

The example creates a small VPC surface and a BetterNAT gateway group so
maintainers can check module wiring from a clean stack. Do not use it as a
production VPC template.

Review the region, CIDR, and resource names before applying:

```sh
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` after the smoke test and confirm no run-scoped resources
remain.
