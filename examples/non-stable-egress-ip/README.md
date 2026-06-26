# Non-Stable Egress IP Example

This is a runnable example for the AWS BetterNAT module. It is not a reusable
Terraform submodule.

The example disables the shared stable EIP. Use it when preserving private
workload connectivity is more important than keeping one public egress IP.

Replace the placeholder VPC, subnet, and route table IDs in `main.tf`, then run:

```sh
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` when the validation stack is no longer needed.
