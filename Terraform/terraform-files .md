variables.tf

```
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Deployment region"
  type        = string
}

variable "credentials_file" {
  description = "Path to credentials JSON"
  type        = string
}

variable "vpc_name" {
  type = string
}

variable "subnets" {
  type = map(object({
    cidr = string
    name = string
  }))
  description = "Map of subnet names and CIDRs"
}

variable "pod_range" {
  description = "CIDR range for Kubernetes pods"
  type        = string
}

variable "service_range" {
  description = "CIDR range for Kubernetes services"
  type        = string
}

variable "firewall_rules" {
  type = list(object({
    name         = string
    ports        = list(string)
    protocol     = string
    source_range = string
    target_tags  = list(string)
  }))
}

variable "artifact_repos" {
  type = list(string)
}

variable "vm_instance_names" {
  type = list(string)
}

variable "vm_subnet_map" {
  description = "Map of VM instance names to subnet keys"
  type        = map(string)
}

variable "private_service_access_name" {
  type = string
}

variable "private_vpc_connection_name" {
  type = string
}

# GKE Variables
variable "gke_clusters" {
  description = "List of GKE cluster names"
  type        = list(string)
}

variable "node_locations" {
  description = "List of zones for GKE nodes"
  type        = list(string)
  default     = ["us-east1-b", "us-east1-c", "us-east1-d"]
}

variable "node_pools" {
  description = "Map of node pools for GKE clusters"
  type = map(object({
    cluster        = string
    initial_count  = number
    min_count      = number
    max_count      = number
    machine_type   = string
    node_locations = list(string)
    location_policy = string
    taints         = list(object({
      key    = string
      value  = string
      effect = string
    }))
    labels         = map(string)
    metadata       = map(string)
  }))
}

variable "master_ipv4_cidr_blocks" {
  description = "Map of CIDR blocks for GKE masters per cluster"
  type        = map(string)
  default     = {
    "drip-nonprod" = "172.16.0.0/28"
  }
}

variable "authorized_networks" {
  description = "Authorized networks for GKE master access"
  type        = map(string)
  default     = {
    "all" = "0.0.0.0/0"
  }
}

variable "disk_type" {
  description = "Disk type for GKE nodes"
  type        = string
  default     = "pd-balanced"
}

variable "disk_types" {
  description = "Map of disk types for GKE clusters"
  type        = map(string)
  default     = {
    "drip-nonprod" = "pd-ssd"
  }
}

variable "disk_size" {
  description = "Disk size for GKE nodes in GB"
  type        = number
  default     = 10
}

variable "image_type" {
  description = "Image type for GKE nodes"
  type        = string
  default     = "COS_CONTAINERD"
}

variable "service_account_email" {
  description = "Service account email for GKE nodes"
  type        = string
  default     = "default"
}

variable "maintenance_start_time" {
  description = "Start time for GKE maintenance window"
  type        = string
}

variable "maintenance_end_time" {
  description = "End time for GKE maintenance window"
  type        = string
}

variable "maintenance_recurrence" {
  description = "Recurrence rule for GKE maintenance window"
  type        = string
}

# Cloud Routers and NAT Variables
variable "cloud_routers" {
  type = map(string) # map of router name => environment
}

variable "nat_configs" {
  type = map(object({
    router = string
  }))
}

# VPN Variables
variable "vpn_gateways" {
  description = "Map of VPN Gateway names to their environments"
  type        = map(string)
}

variable "peer_vpn_gateways" {
  description = "Map of Peer VPN Gateways for external connectivity"
  type = map(object({
    env        = string
   ip_address = string
  }))
}

variable "vpn_tunnels" {
  description = "Map of VPN Tunnels configurations"
  type = map(object({
    env           = string
    tunnel_id     = number
    peer_gateway  = string
    shared_secret = string
    router        = string
  }))


variable "bgp_sessions" {
  description = "Map of BGP sessions for VPN tunnels"
  type = map(object({
    env      = string
    bgp_id   = number
    ip_range = string
    peer_ip  = string
    router   = string
  }))
}

variable "gcp_asn" {
  description = "ASN for GCP Cloud Routers"
  type        = number
}

variable "aws_asn" {
  description = "ASN for AWS Peer in BGP sessions"
  type        = number
}
```




terraform.tf
```
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.36.0"
    }
  }

  required_version = ">= 1.3.0"
}
```
outputs.tf
```
# VPC 
output "vpc_name" {
  value       = google_compute_network.vpc.name
}

# Subnets
output "subnet_names" {
  value       = [for s in google_compute_subnetwork.subnets : s.name]
}

# Cloud Router
output "cloud_router_names" {
  value = {
    for k, r in google_compute_router.routers : k => r.name
  }
}

# CLoud Nat
output "cloud_nat_names" {
  value = {
    for k, n in google_compute_router_nat.nat : k => n.name
  }
}

# GKE Cluster Outputs    
output "gke_cluster_names" {
  value       = [for name, cluster in google_container_cluster.gke : cluster.name]
}

# GKE Node Pool Outputs   
output "gke_node_pool_names" {
  value       = [for name, np in google_container_node_pool.node_pools : np.name]
}

# VM Instance Outputs
output "vm_names" {
  value       = [for vm in google_compute_instance.vms : vm.name]
}

# Artifact Registry Outputs
output "artifact_repo_names" {
  value       = [for r in google_artifact_registry_repository.repos : r.name]
}

# VPN Outputs
output "vpn_gateway_names" {
  value       = [for name, gw in google_compute_vpn_gateway.vpn_gateways : name]
}

output "peer_vpn_gateway_names" {
  value       = [for name, gw in google_compute_external_vpn_gateway.peer_vpn_gateways : name]
}

output "vpn_tunnel_names" {
  value       = [for name, tunnel in google_compute_vpn_tunnel.vpn_tunnels : name]
}

output "bgp_session_names" {
  value       = [for name, peer in google_compute_router_peer.bgp_peers : name]
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
region             = "us-east1"
credentials_file   = "/home/logesh/ranjitha/gcp/credential.json"
pod_range          = "10.4.0.0/14"
service_range      = "10.1.0.0/20"
vpc_name           = "ranjitha-tf"
disk_size          = 30
disk_types = {
  "drip-nonprod" = "pd-ssd"
}

subnets = {
  public   = { cidr = "10.0.1.0/24", name = "ranjitha-nonprod-public-subnet" },
  private  = { cidr = "10.0.2.0/24", name = "ranjitha-nonprod-private-subnet" },
  db       = { cidr = "10.0.3.0/24", name = "ranjitha-nonprod-database-subnet" }
}

firewall_rules = [
  {
    name         = "drip-nonprod-allow-http"
    ports        = ["80"]
    protocol     = "tcp"
    source_range = "0.0.0.0/0"
    target_tags  = ["http-server"]
  },
  {
    name         = "drip-nonprod-allow-https"
    ports        = ["443"]
    protocol     = "tcp"
    source_range = "0.0.0.0/0"
    target_tags  = ["https-server"]
  },
  {
    name         = "drip-nonprod-bastion-ingress"
    ports        = ["22"]
    protocol     = "tcp"
    source_range = "0.0.0.0/0"
    target_tags  = ["ssh"]
  },
  {
    name         = "allow-ssh-from-iap-drip-nonprod"
    ports        = ["22"]
    protocol     = "tcp"
    source_range = "35.235.240.0/20"
    target_tags  = ["iap-ssh"]
  }
]

artifact_repos = [
  "feat-ashwin-1", "feat-chetan-1", "feat-dinesh-1", "feat-shripal-1", "feat-sonu-1",
  "feature-branch", "staging", "production", "runner", "common"
]

vm_instance_names = [
  "ranjitha-drip-nonprod-bastion"
]

vm_subnet_map = {
  "ranjitha-drip-nonprod-bastion" = "public"
}

private_service_access_name = "ranjitha-drip-nonprod-private-connection-ip"
private_vpc_connection_name = "ranjitha-drip-nonprod-private-connection"
master_ipv4_cidr_blocks = {
  "drip-nonprod" = "172.16.0.0/28"
}

# Cloud Routers and NAT
cloud_routers = {
  "drip-nonprod-public-router" = "nonprod",
  "drip-nonprod-feature-branch-router" = "feature",
  "drip-nonprod-staging-router" = "staging"
}

nat_configs = {
  "drip-nonprod-nat" = {
    router = "drip-nonprod-public-router"
  }
}

# GKE Configurations
gke_clusters = [
  "drip-nonprod"
]

node_locations = [
  "us-east1-b",
  "us-east1-c",
  "us-east1-d"
]

authorized_networks = {
  "nonprod-public-subnet" = "10.10.0.0/20",
  "nonprod-nat-1"         = "35.231.110.156/32",
  "nonprod-nat-2"         = "35.229.48.81/32",
  "my-ip"                 = "157.49.246.103/32"
}

node_pools = {
  "e2-standard-2-pool" = {
    cluster        = "drip-nonprod"
    initial_count  = 0
    min_count      = 0
    max_count      = 1
    machine_type   = "e2-micro"
    node_locations = ["us-east1-b", "us-east1-c", "us-east1-d"]
    location_policy = "BALANCED"
    taints         = []
    labels         = {}
    metadata       = {}
  },
  "gke-runner-pool-1" = {
    cluster        = "drip-nonprod"
    initial_count  = 0
    min_count      = 0
    max_count      = 1
    machine_type   = "e2-micro"
    node_locations = ["us-east1-b"]
    location_policy = "ANY"
    taints         = [
      {
        key    = "runner-only"
        value  = "true"
        effect = "NO_SCHEDULE"
      }
    ]
    labels         = {
      "purpose" = "github-runner"
    }
    metadata       = {}
  }
}

maintenance_start_time = "2025-06-01T18:30:00Z"
maintenance_end_time   = "2025-06-02T18:30:00Z"
maintenance_recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"

# VPN Configurations
vpn_gateways = {
  "drip-nonprod-feature-branch-vpn-gateway" = "feature-branch",
  "drip-nonprod-staging-vpn-gateway" = "staging"
}

peer_vpn_gateways = {
  "drip-nonprod-feature-branch-peer-vpn-gateway" = { env = "feature-branch", ip_address = "AWS_PUBLIC_IP_FEATURE" },
  "drip-nonprod-staging-peer-vpn-gateway" = { env = "staging", ip_address = "AWS_PUBLIC_IP_STAGING" }
}

vpn_tunnels = {
  "drip-nonprod-feature-branch-tunnel-1" = { env = "feature-branch", tunnel_id = 1, peer_gateway = "drip-nonprod-feature-branch-peer-vpn-gateway", shared_secret = "secret-1", router = "drip-nonprod-feature-branch-router" },
  "drip-nonprod-feature-branch-tunnel-2" = { env = "feature-branch", tunnel_id = 2, peer_gateway = "drip-nonprod-feature-branch-peer-vpn-gateway", shared_secret = "secret-2", router = "drip-nonprod-feature-branch-router" },
  "drip-nonprod-feature-branch-tunnel-3" = { env = "feature-branch", tunnel_id = 3, peer_gateway = "drip-nonprod-feature-branch-peer-vpn-gateway", shared_secret = "secret-3", router = "drip-nonprod-feature-branch-router" },
  "drip-nonprod-feature-branch-tunnel-4" = { env = "feature-branch", tunnel_id = 4, peer_gateway = "drip-nonprod-feature-branch-peer-vpn-gateway", shared_secret = "secret-4", router = "drip-nonprod-feature-branch-router" },
  "drip-nonprod-staging-tunnel-1" = { env = "staging", tunnel_id = 1, peer_gateway = "drip-nonprod-staging-peer-vpn-gateway", shared_secret = "secret-5", router = "drip-nonprod-staging-router" },
  "drip-nonprod-staging-tunnel-2" = { env = "staging", tunnel_id = 2, peer_gateway = "drip-nonprod-staging-peer-vpn-gateway", shared_secret = "secret-6", router = "drip-nonprod-staging-router" },
  "drip-nonprod-staging-tunnel-3" = { env = "staging", tunnel_id = 3, peer_gateway = "drip-nonprod-staging-peer-vpn-gateway", shared_secret = "secret-7", router = "drip-nonprod-staging-router" },
  "drip-nonprod-staging-tunnel-4" = { env = "staging", tunnel_id = 4, peer_gateway = "drip-nonprod-staging-peer-vpn-gateway", shared_secret = "secret-8", router = "drip-nonprod-staging-router" }
}

bgp_sessions = {
  "drip-nonprod-feature-branch-bgp-1" = { env = "feature-branch", bgp_id = 1, ip_range = "169.254.1.1/30", peer_ip = "169.254.1.2", router = "drip-nonprod-feature-branch-router" },
  "drip-nonprod-feature-branch-bgp-2" = { env = "feature-branch", bgp_id = 2, ip_range = "169.254.1.5/30", peer_ip = "169.254.1.6", router = "drip-nonprod-feature-branch-router" },
  "drip-nonprod-feature-branch-bgp-3" = { env = "feature-branch", bgp_id = 3, ip_range = "169.254.1.9/30", peer_ip = "169.254.1.10", router = "drip-nonprod-feature-branch-router" },
  "drip-nonprod-feature-branch-bgp-4" = { env = "feature-branch", bgp_id = 4, ip_range = "169.254.1.13/30", peer_ip = "169.254.1.14", router = "drip-nonprod-feature-branch-router" },
  "drip-nonprod-staging-bgp-1" = { env = "staging", bgp_id = 1, ip_range = "169.254.2.1/30", peer_ip = "169.254.2.2", router = "drip-nonprod-staging-router" },
  "drip-nonprod-staging-bgp-2" = { env = "staging", bgp_id = 2, ip_range = "169.254.2.5/30", peer_ip = "169.254.2.6", router = "drip-nonprod-staging-router" },
  "drip-nonprod-staging-bgp-3" = { env = "staging", bgp_id = 3, ip_range = "169.254.2.9/30", peer_ip = "169.254.2.10", router = "drip-nonprod-staging-router" },
  "drip-nonprod-staging-bgp-4" = { env = "staging", bgp_id = 4, ip_range = "169.254.2.13/30", peer_ip = "169.254.2.14", router = "drip-nonprod-staging-router" }
}

gcp_asn = 64514
aws_asn = 65001
```
