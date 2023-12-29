resource "libvirt_cloudinit_disk" "cloudinit" {
  name           = "${var.name}-cloudinit.iso"
  pool           = var.pool_name
  user_data      = var.user_data
  network_config = local.network_config
}
