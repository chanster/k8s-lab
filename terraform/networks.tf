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

# resource "libvirt_network" "k3s" {
#   name      = var.k3s_network.domain
#   mode      = "bridge"
#   bridge    = "virbr1"
#   autostart = true

#   depends_on = [ libvirt_network.bridge ]
# }
