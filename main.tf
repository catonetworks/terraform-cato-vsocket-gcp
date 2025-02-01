# main.tf
provider "google" {
  project = var.project
  region  = var.region
}

# # Data sources to fetch existing resources
# data "google_compute_network" "existing_vpc_mgmt" {
#   name = var.existing_vpc_mgmt_name
# }

# data "google_compute_network" "existing_vpc_wan" {
#   name = var.existing_vpc_wan_name
# }

# data "google_compute_network" "existing_vpc_lan" {
#   name = var.existing_vpc_lan_name
# }

# data "google_compute_subnetwork" "existing_subnet_mgmt" {
#   name   = var.existing_subnet_mgmt_name
#   region = var.region
# }

# data "google_compute_subnetwork" "existing_subnet_wan" {
#   name   = var.existing_subnet_wan_name
#   region = var.region
# }

# data "google_compute_subnetwork" "existing_subnet_lan" {
#   name   = var.subnet_lan_name
#   region = var.region
# }

# data "google_compute_address" "existing_ip_mgmt" {
#   name   = var.ip_mgmt_name
#   region = var.region
# }

# data "google_compute_address" "existing_ip_wan" {
#   name   = var.ip_wan_name
#   region = var.region
# }

# firewall.tf
resource "google_compute_firewall" "allow_ssh_https" {
  count   = var.create_firewall_rule ? 1 : 0
  name    = var.firewall_rule_name
  network = var.mgmt_compute_network_id

  allow {
    ports    = var.allowed_ports
    protocol = "tcp"
  }

  source_ranges = var.management_source_ranges
  target_tags   = ["vsocket"]
}

# Boot disk
resource "google_compute_disk" "boot_disk" {
  name  = "${var.vm_name}-boot-disk"
  type  = "pd-balanced"
  zone  = var.zone
  size  = var.boot_disk_size
  image = var.boot_disk_image
}

# VM Instance
resource "google_compute_instance" "vsocket" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  can_ip_forward = true

  boot_disk {
    auto_delete = true
    source      = google_compute_disk.boot_disk.self_link
  }

  # Management interface
  network_interface {
    network    = var.mgmt_compute_network_id
    subnetwork = var.mgmt_subnet_id
    network_ip = var.mgmt_network_ip
    nic_type   = "GVNIC"

    dynamic "access_config" {
      for_each = var.public_ip_mgmt ? [1] : []
      content {
        nat_ip       = var.mgmt_static_ip_address
        network_tier = var.network_tier
      }
    }
  }

  # WAN interface
  network_interface {
    network    = var.wan_compute_network_id
    subnetwork = var.wan_subnet_id
    network_ip = var.wan_network_ip
    nic_type   = "GVNIC"

    dynamic "access_config" {
      for_each = var.public_ip_wan ? [1] : []
      content {
        nat_ip       = var.wan_static_ip_address
        network_tier = var.network_tier
      }
    }
  }

  # LAN interface
  network_interface {
    network    = var.lan_compute_network_id
    subnetwork = var.lan_subnet_id
    network_ip = var.lan_network_ip
    nic_type   = "GVNIC"
  }

  # Custom metadata with serial id
  metadata = {
    cato-serial-id = var.cato-serial-id
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["vsocket"]
}