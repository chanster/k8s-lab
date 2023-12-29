terraform {
  required_providers {
    libvirt = {
      source  = "registry.terraform.io/dmacvicar/libvirt"
      version = "~> 0.7.6"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.3"
    }
  }
}
