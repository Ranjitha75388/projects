mamin.tf
```
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# VPC
resource "google_compute_network" "gke_network" {
  name                    = "gke-custom-network"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "gke_subnet" {
  name                     = "gke-subnet"
  ip_cidr_range            = "10.20.0.0/16"
  region                   = var.region
  network                  = google_compute_network.gke_network.id
  private_ip_google_access = true
}

# ✅ Autopilot GKE Cluster (no node pool, no SSD disk config needed)
resource "google_container_cluster" "gke_cluster" {
  name               = "gke-cluster-${var.region}"
  location           = var.region
  network            = google_compute_network.gke_network.id
  subnetwork         = google_compute_subnetwork.gke_subnet.name
  enable_autopilot   = true
  deletion_protection = false

  ip_allocation_policy {}
}
```
variable.tf
```
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Region to deploy resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zone for node pool"
  type        = string
  default     = "us-central1-c"
}

```
terraform.tfvars
```
project_id = "nomadic-rite-456619-e1"
region     = "us-central1"
zone       = "us-central1-c"
```




