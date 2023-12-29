resource "libvirt_volume" "alpine" {
  name   = "${var.name}-base.qcow2"
  pool   = var.pool_name
  source = local.base_image
}
