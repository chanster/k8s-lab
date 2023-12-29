resource "libvirt_volume" "root" {
  name           = "${var.name}-root.qcow2"
  base_volume_id = libvirt_volume.alpine.id
  size           = var.disk_size * 1024 * 1024 * 1024 # convert GiB to bytes
  pool           = var.pool_name
}

resource "libvirt_domain" "main" {
  name = var.name
  vcpu = var.cpus

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    network_id     = var.network.network_id
    hostname       = "${var.name}.${var.network.domain}"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.root.id
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit.id
}
