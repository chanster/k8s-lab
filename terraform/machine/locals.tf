locals {
  network_config = file("${path.module}/cloud-inits/network_config.yaml")
  base_image     = var.base_image == null ? "${trimsuffix(path.cwd, "/terraform")}/bin/images/alpine-v3.18.5.qcow2" : var.base_image
}
