# Cato Networks GCP vSocket Terraform Module

The Cato vSocket modules deploys a vSocket instance to connect to the Cato Cloud.

# Pre-reqs
- Install the [Google Cloud Platform CLI](https://cloud.google.com/sdk/docs/install)
`$ /google-cloud-sdk/install.sh`
- Run the following to configure the GCP CLI
`$ gcloud auth application-default login`

This module deploys the following resources
- 1 google_compute_instance
- 1 google_compute_disk
- 1 google_compute_firewall (optional)

# GCP Network and Resource Dependencies

<details>
<summary>Create new GCP VPC and network resources</summary>

The following exmaple shows how to create the required resources as new.

```hcl
# VPC Networks
resource "google_compute_network" "vpc_mgmt" {
  name                    = var.vpc_mgmt_name
  auto_create_subnetworks = false
}

resource "google_compute_network" "vpc_wan" {
  name                    = var.vpc_wan_name
  auto_create_subnetworks = false
}

resource "google_compute_network" "vpc_lan" {
  name                    = var.vpc_lan_name
  auto_create_subnetworks = false
}

# Subnets
resource "google_compute_subnetwork" "subnet_mgmt" {
  name          = var.subnet_mgmt_name
  ip_cidr_range = var.subnet_mgmt_cidr
  network       = google_compute_network.vpc_mgmt.id
  region        = var.region
}

resource "google_compute_subnetwork" "subnet_wan" {
  name          = var.subnet_wan_name
  ip_cidr_range = var.subnet_wan_cidr
  network       = google_compute_network.vpc_wan.id
  region        = var.region
}

resource "google_compute_subnetwork" "subnet_lan" {
  name          = var.subnet_lan_name
  ip_cidr_range = var.subnet_lan_cidr
  network       = google_compute_network.vpc_lan.id
  region        = var.region
}

# Static IPs
resource "google_compute_address" "ip_mgmt" {
  count        = var.public_ip_mgmt ? 1 : 0
  name         = var.ip_mgmt_name
  region       = var.region
  network_tier = var.network_tier
}

resource "google_compute_address" "ip_wan" {
  count        = var.public_ip_wan ? 1 : 0
  name         = var.ip_wan_name
  region       = var.region
  network_tier = var.network_tier
}

resource "google_compute_address" "ip_lan" {
  name         = var.ip_lan_name
  region       = var.region
  address_type = "INTERNAL"
  subnetwork   = google_compute_subnetwork.subnet_lan.id
}
```

</details>

<details>
<summary>Use existing GCP VPC and network resources (data sources)</summary>

The following exmaple shows how to use existing resources in GCP retrieving the necessary values using GCP data sources.

```hcl
# VPC Networks
data "google_compute_network" "vpc_mgmt" {
  name                    = var.vpc_mgmt_name
}

data "google_compute_network" "vpc_wan" {
  name                    = var.vpc_wan_name
}

data "google_compute_network" "vpc_lan" {
  name                    = var.vpc_lan_name
}

# Subnets
data "google_compute_subnetwork" "subnet_mgmt" {
  name          = var.subnet_mgmt_name
  region        = var.region
}

data "google_compute_subnetwork" "subnet_wan" {
  name          = var.subnet_wan_name
  region        = var.region
}

data "google_compute_subnetwork" "subnet_lan" {
  name          = var.subnet_lan_name
  region        = var.region
}

# Static IPs
data "google_compute_address" "ip_mgmt" {
  name         = var.ip_mgmt_name
}

data "google_compute_address" "ip_wan" {
  name         = var.ip_wan_name
}

data "google_compute_address" "ip_lan" {
  name         = var.ip_lan_name
}
```

</details>

## Usage

```hcl
# GCP/Cato vsocket Module
module "vsocket-gpc" {
  source                   = "catonetworks/vsocket-gcp/cato"
  token                    = var.cato_token
  account_id               = var.account_id
  allowed_ports            = ["22", "443"]
  create_firewall_rule     = true
  firewall_rule_name       = "allow-management-access" # Only used if create_firewall_rule = true
  lan_compute_network_id   = google_compute_network.vpc_lan.id
  native_network_range     = "10.2.0.0/24"
  lan_network_ip           = "10.2.0.10" 
  lan_subnet_id            = google_compute_subnetwork.subnet_lan.id
  management_source_ranges = ["11.22.33.44/32"] # Only used if create_firewall_rule = true
  mgmt_compute_network_id  = google_compute_network.vpc_mgmt.id
  mgmt_network_ip          = "10.0.0.10"
  mgmt_static_ip_address   = google_compute_address.ip_mgmt[0].address
  mgmt_subnet_id           = google_compute_subnetwork.subnet_mgmt.id
  project                  = "cato-vsocket-deployment"
  region                   = "us-west1"
  site_name                = "Cato-GCP-us-west1"
  site_description         = "GCP Site us-west1"
  site_location            = {
    city         = "Los Angeles"
    country_code = "US"
    state_code   = "US-CA" ## Optional - for countries with states
    timezone     = "America/Los_Angeles"
  }
  vm_name                  = "gcp-vsocket-instance"
  wan_compute_network_id   = google_compute_network.vpc_wan.id
  wan_network_ip           = "10.1.0.10"
  wan_static_ip_address    = google_compute_address.ip_wan[0].address
  wan_subnet_id            = google_compute_subnetwork.subnet_wan.id
  zone                     = "us-west1-a"
  tags                     = ["customtag1","tcustomtag1est2"]
  labels                   = {
    customLabel = "mylabel"
    customLabel = "mylabel2"
  }
}
```
