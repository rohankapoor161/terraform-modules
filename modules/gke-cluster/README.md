# GKE Cluster Module

Production-ready GKE cluster with security and observability best practices.

## Features

- Private nodes (default)
- Workload Identity enabled
- Network policies enabled
- Auto-repair and auto-upgrade
- Weekend maintenance windows
- Cost tracking labels

## Usage

```hcl
module "gke" {
  source = "github.com/rohankapoor161/terraform-modules//modules/gke-cluster?ref=v1.0.0"
  
  cluster_name = "prod-cluster"
  project_id   = "my-project"
  region       = "us-central1"
  network      = "vpc-network"
  subnetwork   = "subnet-01"
}
```

## Inputs

See [variables.tf](./variables.tf) for complete input reference.

## Outputs

See [outputs.tf](./outputs.tf) for output reference.
