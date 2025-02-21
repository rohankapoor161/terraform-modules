# Terraform Modules

Production-ready Terraform modules for GCP, AWS, and Kubernetes infrastructure. Battle-tested at Vercel, Stripe, and Google Cloud.

## Philosophy

**Opinionated defaults, flexible escape hatches.**

These modules encode lessons from years of production infrastructure management. They make safe choices by default but allow customization when needed.

## Module Registry

| Module | Cloud | Description | Version |
|--------|-------|-------------|---------|
| [gke-cluster](./modules/gke-cluster) | GCP | Production GKE cluster with best practices | v1.0.0 |
| [vpc-network](./modules/vpc-network) | GCP/AWS | Secure VPC with subnets and firewall rules | v1.0.0 |
| [gcs-bucket](./modules/gcs-bucket) | GCP | GCS bucket with lifecycle policies | v1.0.0 |
| [s3-bucket](./modules/s3-bucket) | AWS | S3 bucket with versioning and encryption | v1.0.0 |
| [service-account](./modules/service-account) | GCP | IAM service account with minimal permissions | v1.0.0 |

## Quick Start

```hcl
module "gke_cluster" {
  source  = "github.com/rohankapoor161/terraform-modules//modules/gke-cluster?ref=v1.0.0"
  
  cluster_name = "prod-cluster"
  project_id   = "my-project"
  region       = "us-central1"
  
  # Safe defaults applied automatically
  enable_private_nodes    = true
  enable_workload_identity = true
  enable_network_policy   = true
}
```

## Design Principles

1. **Security by default**
   - Private clusters
   - Least-privilege IAM
   - Encryption at rest and in transit

2. **Observability built-in**
   - Cloud Monitoring integration
   - Audit logging enabled
   - Cost tracking labels

3. **Reliability patterns**
   - Multi-zonal deployments
   - Automatic backups
   - Health checks configured

## Usage

Each module has its own README with:
- Complete input variable reference
- Output descriptions
- Usage examples
- Migration guides

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for module development guidelines.

## License

Apache 2.0
