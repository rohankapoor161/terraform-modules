# GKE Cluster Module
# Production-ready GKE cluster with security and observability best practices

locals {
  cluster_name = var.cluster_name
  project_id   = var.project_id
  region       = var.region
}

# GKE Cluster
resource "google_container_cluster" "primary" {
  name     = local.cluster_name
  location = local.region
  project  = local.project_id

  # Network configuration
  network    = var.network
  subnetwork = var.subnetwork

  # Private cluster configuration
  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  # IP allocation policy
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  # Workload identity
  workload_identity_config {
    workload_pool = "${local.project_id}.svc.id.goog"
  }

  # Network policy
  network_policy {
    enabled  = var.enable_network_policy
    provider = "CALICO"
  }

  # Release channel
  release_channel {
    channel = var.release_channel
  }

  # Maintenance policy
  maintenance_policy {
    recurring_window {
      start_time = var.maintenance_start_time
      end_time   = var.maintenance_end_time
      recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"
    }
  }

  # Monitoring and logging
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  depends_on = [google_project_service.container]
}

# Enable required APIs
resource "google_project_service" "container" {
  service = "container.googleapis.com"
  project = local.project_id
}

# Node pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${local.cluster_name}-nodes"
  location   = local.region
  cluster    = google_container_cluster.primary.name
  project    = local.project_id
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type

    # Workload identity on nodes
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    # Labels for cost tracking
    labels = merge(var.node_labels, {
      cluster = local.cluster_name
    })

    # Service account
    service_account = var.node_service_account

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
}
