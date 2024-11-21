# VPC Network Module
# Secure VPC with subnets, firewall rules, and private Google Access

locals {
  network_name = var.network_name
  project_id   = var.project_id
  region       = var.region
}

# VPC Network
resource "google_compute_network" "vpc" {
  name                    = local.network_name
  project                 = local.project_id
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"

  depends_on = [google_project_service.compute]
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${local.network_name}-subnet"
  project       = local.project_id
  region        = local.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_cidr

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr
  }

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Firewall: Allow internal
resource "google_compute_firewall" "allow_internal" {
  name    = "${local.network_name}-allow-internal"
  project = local.project_id
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [var.subnet_cidr]
}

# Firewall: Allow SSH from IAP
resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "${local.network_name}-allow-iap-ssh"
  project = local.project_id
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}

# Enable Compute API
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
  project = local.project_id
}
