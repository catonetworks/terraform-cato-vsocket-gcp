# variables.tf
variable "project" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "me-west1"
  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]$", var.region))
    error_message = "Region must be in the format: region-location (e.g., us-central1)."
  }
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "me-west1-a"
}

# Existing VPC Names (REQUIRED)
variable "mgmt_compute_network_id" {
  description = "ID of existing Management Compute Network"
  type        = string
}

variable "wan_compute_network_id" {
  description = "ID of existing WAN Compute Network"
  type        = string
}

variable "lan_compute_network_id" {
  description = "ID of existing LAN Compute Network"
  type        = string
}

# Existing Subnet Names (REQUIRED)
variable "mgmt_subnet_id" {
  description = "ID of existing Management Subnet"
  type        = string
}

variable "wan_subnet_id" {
  description = "ID of existing WAN Subnet"
  type        = string
}

variable "lan_subnet_id" {
  description = "ID of existing LAN Subnet"
  type        = string
}

# Existing IP Names (REQUIRED)
variable "mgmt_static_ip_address" {
  description = "Name of existing Management Static IP"
  type        = string
}

variable "wan_static_ip_address" {
  description = "Name of existing WAN Static IP"
  type        = string
}

# Boot Disk Configuration
variable "boot_disk_size" {
  description = "Boot disk size in GB (minimum 10 GB)"
  type        = number
  default     = 10
  validation {
    condition     = var.boot_disk_size >= 10
    error_message = "Boot disk size must be at least 10 GB."
  }
}

variable "boot_disk_image" {
  description = "Boot disk image"
  type        = string
}

variable "network_tier" {
  description = "Network tier for the public IP"
  type        = string
  default     = "STANDARD"
}

# Network IP Configuration (REQUIRED)
variable "mgmt_network_ip" {
  description = "Management network IP"
  type        = string
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.mgmt_network_ip))
    error_message = "Management network IP must be a valid IPv4 address."
  }
}

variable "wan_network_ip" {
  description = "WAN network IP"
  type        = string
}

variable "lan_network_ip" {
  description = "LAN network IP"
  type        = string
}

# VM Configuration
variable "vm_name" {
  description = "VM Instance name (must be 1-63 characters, lowercase letters, numbers, or hyphens)"
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.vm_name))
    error_message = "VM name must be 1-63 characters long, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "machine_type" {
  description = "Machine type"
  type        = string
  validation {
    condition     = can(regex("^[a-z][0-9]-[a-z]+-[0-9]+$", var.machine_type))
    error_message = "Machine type must be in the format: family-series-size (e.g., n2-standard-4)."
  }
}

# Metadata Configuration
variable "cato-serial-id" {
  description = "Serial ID for the metadata (Required)"
  type        = string
  validation {
    condition     = length(var.cato-serial-id) > 0
    error_message = "The cato-serial-id value is required and cannot be empty."
  }
}

# Public IP Configuration
variable "public_ip_mgmt" {
  description = "Whether to assign the existing static IP to management interface. If false, no public IP will be assigned."
  type        = bool
  default     = true
}

variable "public_ip_wan" {
  description = "Whether to assign the existing static IP to WAN interface. If false, no public IP will be assigned."
  type        = bool
  default     = true
}

# Firewall Configuration
variable "firewall_rule_name" {
  description = "Name of the firewall rule (1-63 chars, lowercase letters, numbers, or hyphens)"
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.firewall_rule_name))
    error_message = "Firewall rule name must be 1-63 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "allowed_ports" {
  description = "List of ports to allow through the firewall (Required)"
  type        = list(string)
  validation {
    condition     = length(var.allowed_ports) > 0
    error_message = "At least one port must be specified."
  }
}

variable "management_source_ranges" {
  description = "Source IP ranges that can access the instance via SSH/HTTPS (Required)"
  type        = list(string)
  validation {
    condition     = length(var.management_source_ranges) > 0
    error_message = "At least one source IP range must be provided for management access."
  }
}

variable "create_firewall_rule" {
  description = "Whether to create the firewall rule for management access"
  type        = bool
  default     = true
}