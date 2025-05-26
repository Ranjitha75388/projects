variables.tf

```
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
  default     = "us-central1"
}

variable "credentials_file" {
  description = "Path to the GCP credentials JSON file"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "ranjitha-tf-vpc"
}

variable "public_subnet_cidr" {
  description = "CIDR range for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR range for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "db_subnet_cidr" {
  description = "CIDR range for the database subnet"
  type        = string
  default     = "10.0.3.0/24"
}
```




terraform.tf
```
terraform {
  required_version = ">= 1.3.0"  

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.36.0"  # Provider version (not Terraform core version)
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.credentials_file)
}
```
outputs.tf
```
output "vpc_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.ranjitha_vpc.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = google_compute_subnetwork.subnet_public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = google_compute_subnetwork.subnet_private.id
}

output "db_subnet_id" {
  description = "ID of the database subnet"
  value       = google_compute_subnetwork.subnet_db.id
}

output "cloud_router_name" {
  description = "Name of the Cloud Router"
  value       = google_compute_router.router.name
}

output "cloud_nat_name" {
  description = "Name of the Cloud NAT"
  value       = google_compute_router_nat.nat.name
}
```
main.tf
```
resource "google_compute_network" "ranjitha_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_public" {
  name          = "public-subnet"
  ip_cidr_range = var.public_subnet_cidr
  region        = var.region
  network       = google_compute_network.ranjitha_vpc.id
}

resource "google_compute_subnetwork" "subnet_private" {
  name                     = "private-subnet"
  ip_cidr_range            = var.private_subnet_cidr
  region                   = var.region
  network                  = google_compute_network.ranjitha_vpc.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnet_db" {
  name                     = "db-subnet"
  ip_cidr_range            = var.db_subnet_cidr
  region                   = var.region
  network                  = google_compute_network.ranjitha_vpc.id
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = google_compute_network.ranjitha_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
  direction     = "INGRESS"
}

resource "google_compute_firewall" "allow-https" {
  name    = "allow-https"
  network = google_compute_network.ranjitha_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
  direction     = "INGRESS"
}

resource "google_compute_firewall" "bastion-ingress" {
  name    = "bastion-ingress"
  network = google_compute_network.ranjitha_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
}

resource "google_compute_router" "router" {
  name    = "ranjitha-router"
  network = google_compute_network.ranjitha_vpc.id
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  name                               = "ranjitha-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.subnet_private.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
```
terraform.tfvars
```
project_id         = "nomadic-rite-456619-e1"
region             = "us-central1"
credentials_file   = "/home/logesh/ranjitha/gcp/credential.json"
vpc_name           = "ranjitha-tf-vpc"
public_subnet_cidr = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
db_subnet_cidr     = "10.0.3.0/24"
```
