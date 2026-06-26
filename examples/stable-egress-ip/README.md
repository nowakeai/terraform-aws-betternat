# Stable Egress IP Example

This is a runnable example for the AWS BetterNAT module. It is not a reusable
Terraform submodule.

The example enables the default stable shared EIP mode. Use it when private
workloads should keep one public egress identity across BetterNAT handover or
failover events.

Replace the placeholder VPC, subnet, and route table IDs in `main.tf`, then run:

```sh
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` when the validation stack is no longer needed.
