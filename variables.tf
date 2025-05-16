# Cato site variables:
variable "site_name" {
  description = "Name of the vsocket site"
  type        = string
}

variable "site_description" {
  description = "Description of the vsocket site"
  type        = string
}

variable "site_type" {
  description = "The type of the site"
  type        = string
  default     = "CLOUD_DC"
  validation {
    condition     = contains(["DATACENTER", "BRANCH", "CLOUD_DC", "HEADQUARTERS"], var.site_type)
    error_message = "The site_type variable must be one of 'DATACENTER','BRANCH','CLOUD_DC','HEADQUARTERS'."
  }
}

variable "site_location" {
  type = object({
    city         = string
    country_code = string
    state_code   = string
    timezone     = string
  })
}

variable "connection_type" {
  description = "Model of Cato vsocket"
  type        = string
  default     = "SOCKET_GCP1500"
}

variable "native_network_range" {
  type        = string
  description = <<EOT
  	Choose the unique network range your vpc is configured with for your socket that does not conflict with the rest of your Wide Area Network.
    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X
	EOT
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

# variable "lan_compute_network_name" {
#   description = "ID of existing LAN Compute Network"
#   type        = string
# }

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
  default     = "projects/cato-vsocket-production/global/images/gcp-socket-image-v22-0-19207"
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

variable "machine_type" {
  description = "Machine type"
  type        = string
  validation {
    condition     = can(regex("^[a-z][0-9]-[a-z]+-[0-9]+$", var.machine_type))
    error_message = "Machine type must be in the format: family-series-size (e.g., n2-standard-4)."
  }
  default = "n2-standard-4"
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
variable "wan_firewall_rule_name" {
  description = "Name of the external firewall rule (1-63 chars, lowercase letters, numbers, or hyphens)"
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.wan_firewall_rule_name))
    error_message = "Firewall rule name must be 1-63 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
  default = "allow-management-access"
}

variable "lan_firewall_rule_name" {
  description = "Name of the internal firewall rule (1-63 chars, lowercase letters, numbers, or hyphens)"
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.lan_firewall_rule_name))
    error_message = "Firewall rule name must be 1-63 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
  default = "allow-rfc1918-to-cato-lan"
}

variable "allowed_ports" {
  description = "List of ports to allow through the firewall"
  type        = list(string)
  default = null
  # validation {
  #   condition     = length(var.allowed_ports) > 0
  #   error_message = "At least one port must be specified."
  # }
}

variable "management_source_ranges" {
  description = "Source IP ranges that can access the instance via SSH/HTTPS"
  type        = list(string)
  default = null
  # validation {
  #   condition     = length(var.management_source_ranges) > 0
  #   error_message = "At least one source IP range must be provided for management access."
  # }
}

variable "create_firewall_rule" {
  description = "Whether to create the firewall rule for management access"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels to be appended to GCP resources"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to be appended to GCP resources"
  type        = list(string)
  default     = []
}

variable "license_id" {
  description = "The license ID for the Cato vSocket of license type CATO_SITE, CATO_SSE_SITE, CATO_PB, CATO_PB_SSE.  Example License ID value: 'abcde123-abcd-1234-abcd-abcde1234567'.  Note that licenses are for commercial accounts, and not supported for trial accounts."
  type        = string
  default     = null
}

variable "license_bw" {
  description = "The license bandwidth number for the cato site, specifying bandwidth ONLY applies for pooled licenses.  For a standard site license that is not pooled, leave this value null. Must be a number greater than 0 and an increment of 10."
  type        = string
  default     = null
}