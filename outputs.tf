
output "cato_socket_site_id" {
  value = cato_socket_site.gcp-site.id
}

output "cato_socket_site_serial" {
  value = data.cato_accountSnapshotSite.gcp-site.info.sockets[0].serial
}

output "google_compute_disk_id" {
  value = google_compute_disk.boot_disk.id
}

output "google_compute_instance_id" {
  value = google_compute_instance.vsocket.id
}

output "google_compute_instance_self_link" {
  value = google_compute_instance.vsocket.self_link
}

output "google_compute_instance_network_interfaces" {
  value = google_compute_instance.vsocket.network_interface
}