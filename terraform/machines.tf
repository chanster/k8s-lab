module "machine" {
  count = var.hosts

  source = "./machine"

  name = "${var.name}w${format("%02d", count.index + 1)}"
  cpus = var.cpus

  network = {
    network_id = libvirt_network.network.id
    network    = var.network_cidr
    domain     = var.network_domain
  }

  disk_size = 20

  user_data = templatefile("user_data.yaml.tftpl",
    {
      hostname   = "${var.name}w${format("%02d", count.index + 1)}"
      fqdn       = "${var.name}w${format("%02d", count.index + 1)}.${var.network_domain}"
      public_key = var.ssh_key
    }
  )
}
