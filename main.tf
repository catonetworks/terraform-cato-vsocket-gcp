# main.tf
provider "google" {
  project = var.project
  region  = var.region
}

provider "cato" {
  baseurl    = var.baseurl
  token      = var.token
  account_id = var.account_id
}

resource "cato_socket_site" "gcp-site" {
  connection_type = var.connection_type
  description     = var.site_description
  name            = var.site_name
  native_range = {
    native_network_range = var.native_network_range
    local_ip             = var.lan_network_ip
  }
  site_location = var.site_location
  site_type     = var.site_type
}

data "cato_accountSnapshotSite" "gcp-site" {
  id = cato_socket_site.gcp-site.id
}

# Firewall rule
resource "google_compute_firewall" "allow_ssh_https" {
  count   = var.create_firewall_rule ? 1 : 0
  name    = var.firewall_rule_name
  network = var.mgmt_compute_network_id

  allow {
    ports    = var.allowed_ports
    protocol = "tcp"
  }

  source_ranges = var.management_source_ranges
  target_tags = var.tags
}

# Boot disk
resource "google_compute_disk" "boot_disk" {
  name  = "${var.vm_name}-boot-disk"
  type  = "pd-balanced"
  zone  = var.zone
  size  = var.boot_disk_size
  image = var.boot_disk_image
}

resource "null_resource" "destroy_delay" {
  depends_on = [cato_socket_site.gcp-site]

  provisioner "local-exec" {
    when    = destroy
    command = "sleep 30"
  }
}

# VM Instance
resource "google_compute_instance" "vsocket" {
  depends_on = [ cato_socket_site.gcp-site, null_resource.destroy_delay ]
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
    cato-serial-id = data.cato_accountSnapshotSite.gcp-site.info.sockets[0].serial
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = var.tags
  labels = merge(var.labels,{
    name = lower("${var.site_name}-vsocket")
  })
}