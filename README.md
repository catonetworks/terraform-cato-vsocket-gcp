# Cato Networks GCP vSocket Terraform Module

The Cato vSocket modules deploys a vSocket instance to connect to the Cato Cloud.

# Pre-reqs
- Install the [Google Cloud Platform CLI](https://cloud.google.com/sdk/docs/install)
`$ /google-cloud-sdk/install.sh`
- Run the following to configure the GCP CLI
`$ cloud auth application-default login`

This module deploys the following resources
- 1 google_compute_instance
- 1 google_compute_disk
- 1 google_compute_firewall (optional)

## Usage

```hcl
# GCP/Cato vsocket Module
module "vsocket-vpc" {
  source                   = "catonetworks/vsocket-azure/cato"
  allowed_ports            = var.allowed_ports
  boot_disk_image          = var.boot_disk_image
  boot_disk_size           = var.boot_disk_size
  cato-serial-id           = var.cato-serial-id
  create_firewall_rule     = var.create_firewall_rule
  firewall_rule_name       = var.firewall_rule_name
  lan_compute_network_id   = google_compute_network.vpc_lan.id
  lan_network_ip           = var.lan_network_ip
  lan_subnet_id            = google_compute_subnetwork.subnet_lan.id
  machine_type             = var.machine_type
  management_source_ranges = var.management_source_ranges
  mgmt_compute_network_id  = google_compute_network.vpc_mgmt.id
  mgmt_network_ip          = var.mgmt_network_ip
  mgmt_static_ip_address   = google_compute_address.ip_mgmt[0].address
  mgmt_subnet_id           = google_compute_subnetwork.subnet_mgmt.id
  project                  = var.project
  region                   = var.region
  vm_name                  = var.vm_name
  wan_compute_network_id   = google_compute_network.vpc_wan.id
  wan_network_ip           = var.wan_network_ip
  wan_static_ip_address    = google_compute_address.ip_wan[0].address
  wan_subnet_id            = google_compute_subnetwork.subnet_wan.id
  zone                     = var.zone
}
```
