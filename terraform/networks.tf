resource "libvirt_network" "network" {
  name      = "k3s-lab"
  mode      = "nat"
  domain    = var.network_domain
  autostart = true

  addresses = [var.network_cidr]

  dhcp {
    enabled = true
  }

  dns {
    enabled    = true
    local_only = true
  }
}
