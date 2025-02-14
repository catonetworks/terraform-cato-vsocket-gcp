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
