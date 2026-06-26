# EKS VPC Module Example

This is a runnable example for the AWS BetterNAT module. It is not a reusable
Terraform submodule.

The example shows how to pass common `terraform-aws-modules/vpc/aws` outputs
into BetterNAT. Use it as a shape reference for EKS or private-node VPC stacks.

Review the VPC CIDRs, AZs, subnet layout, and route ownership before applying:

```sh
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` when the validation stack is no longer needed.
