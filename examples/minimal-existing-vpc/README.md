# Minimal Existing VPC Example

This is a runnable example for the AWS BetterNAT module. It is not a reusable
Terraform submodule.

Use this example when you already have:

- one VPC,
- one public subnet for the gateway,
- one private route table that BetterNAT may own,
- the private CIDR ranges that should use BetterNAT SNAT.

Replace the placeholder VPC, subnet, and route table IDs in `main.tf`, then run:

```sh
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` when the validation stack is no longer needed.
