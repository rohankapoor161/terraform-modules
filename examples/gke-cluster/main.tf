# Example: GKE Cluster with VPC

provider "google" {
  project = var.project_id
  region  = var.region
}

module "vpc" {
  source = "../../modules/vpc-network"
  
  network_name = "gke-vpc"
  project_id   = var.project_id
  region       = var.region
}

module "gke" {
  source = "../../modules/gke-cluster"
  
  cluster_name = var.cluster_name
  project_id   = var.project_id
  region       = var.region
  network      = module.vpc.network_name
  subnetwork   = module.vpc.subnet_name
}
