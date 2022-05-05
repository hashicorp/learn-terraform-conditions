This configuration uses a VPC, and passes the VPC (by id) into the
`example-app-deployment` module. A data source with a postcondition checks to
ensure that DNS support is enabled on the VPC. However, if the consumer of the
module doesn't enable DNS on the first apply, fixing the problem requires them
to `-target` the VPC. They can't use the normal "fix the problem and re-apply"
workflow, or even "destroy everything and start over" because the postcondition
is checked during the plan phase of any apply/destroy commands.

1. Init

```sh
terraform init
```

1. Apply

```sh
terraform apply -var enable_dns=false -auto-approve
```

Result:

```plaintext
##...
╷
│ Error: Resource postcondition failed
│ 
│   on modules/example-app-deployment/main.tf line 12, in data "aws_vpc" "app":
│   12:       condition     = self.enable_dns_support == true
│     ├────────────────
│     │ self.enable_dns_support is false
│ 
│ The selected VPC must have DNS support enabled.
╵
##...
```

This is expected; the postcondition on the data source is intended to ensure that DNS support is enabled.

1. Apply again, enabling DNS:

```sh
terraform apply -var enable_dns=true -auto-approve
```

Result:

```plaintext
##...
╷
│ Error: Resource postcondition failed
│ 
│   on modules/example-app-deployment/main.tf line 12, in data "aws_vpc" "app":
│   12:       condition     = self.enable_dns_support == true
│     ├────────────────
│     │ self.enable_dns_support is false
│ 
│ The selected VPC must have DNS support enabled.
╵
##...
```

This is a little surprising, but happens because the VPC already exists, and the
postcondition check happens during the plan phase.

1. Destroy

```sh
terraform destroy -var enable_dns=false -auto-approve
```

Result:

```plaintext
##...
╷
│ Error: Resource postcondition failed
│ 
│   on modules/example-app-deployment/main.tf line 12, in data "aws_vpc" "app":
│   12:       condition     = self.enable_dns_support == true
│     ├────────────────
│     │ self.enable_dns_support is false
│ 
│ The selected VPC must have DNS support enabled.
╵
##...
```

Again, the postcondition fails, again because the postcondition check fails during the plan stage.

1. Target the VPC for destruction

```sh
terraform destroy -var enable_dns=false -auto-approve -target=module.vpc
```

Result:

```plaintext
##...
Destroy complete! Resources: 14 destroyed.
```

1. Re-apply

```sh
terraform apply -var enable_dns=true -auto-approve
```

Result:

```plaintext
##...
Apply complete! Resources: 14 added, 0 changed, 0 destroyed.

Outputs:

public_subnets = [
  "subnet-05c13fcd0584d127a",
  "subnet-09ff03c7aa68704f3",
]
```