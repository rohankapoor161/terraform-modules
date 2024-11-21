# VPC Network Module

Secure VPC with subnets, firewall rules, and private Google Access.

## Features

- Custom mode VPC (no auto subnets)
- Private Google Access enabled
- Flow logs enabled
- Internal firewall rules
- IAP SSH access
- GKE-compatible secondary ranges

## Usage

```hcl
module "vpc" {
  source = "github.com/rohankapoor161/terraform-modules//modules/vpc-network?ref=v1.0.0"
  
  network_name = "prod-vpc"
  project_id   = "my-project"
  region       = "us-central1"
}
```
