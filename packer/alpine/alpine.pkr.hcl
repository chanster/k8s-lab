data "http" "checksum" {
  // data sources currently cannot use locals: https://github.com/hashicorp/packer/issues/11011
  url = "${var.base_url}/v${join(".", slice(split(".", var.version), 0, 2))}/${var.repository}/${var.architecture}/alpine-virt-${var.version}-${var.architecture}.iso.sha256"

  request_headers = {
    accept = "text/plain"
  }
}

locals {
  major_minor    = join(".", slice(split(".", var.version), 0, 2))
  alpine_url     = "${var.base_url}/v${local.major_minor}/${var.repository}/${var.architecture}/alpine-virt-${var.version}-${var.architecture}.iso"
  alpine_sha256  = "${local.alpine_url}.sha256"

  packages = [
    "chrony",
    "cloud-init",
    "qemu-guest-agent",
    "dbus",
    "ca-certificates",
    "lsblk",
    "parted",
    "e2fsprogs-extra",
    "lvm2", "device-mapper",
    "sudo", "doas",
    "eudev",
  ]

  services = [
    "setup-cloud-init",
    "rc-update add cloud-init-hotplugd default",
    "rc-update add qemu-guest-agent default",
    "rc-update add chronyd default",
  ]

  # make sure lines end with a space as string is sent as a single line
  kernel_params = <<-EOT
  sed -Ei 
  -e "s|^[# ]*(default_kernel_opts)=.*|\1=\"console=ttyS0,115200n8 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory\"|" 
  -e "s|^[# ]*(serial_port)=.*|\1=ttyS0|" 
  -e "s|^[# ]*(modules)=.*|\1=sd-mod,usb-storage,ext4|" 
  -e "s|^[# ]*(default)=.*|\1=virt|" 
  -e "s|^[# ]*(timeout)=.*|\1=1|" 
  "/etc/update-extlinux.conf"
  EOT
}

source "qemu" "alpine" {
  iso_url          = local.alpine_url
  iso_checksum     = split(" ", data.http.checksum.body)[0] # "7b9df963b46872b195daf527085a8fea76c0576d966a71fd18bcd4e1914f0eae"
  output_directory = "./bin/images/"
  // shutdown_command = "poweroff"
  shutdown_timeout = "10s"
  disk_size        = "1000M"
  format           = "qcow2"
  // accelerator      = "kvm"
  // http_directory   = "path/to/httpdir"
  ssh_username   = "root"
  // ssh_password   = var.root_password
  // ssh_timeout    = "15m"
  vm_name        = "alpine-v${var.version}.qcow2"
  net_device     = "virtio-net"
  disk_interface = "virtio"
  boot_wait      = "10s"
  boot_key_interval = "10ms"
  boot_steps     = [
    ["root<enter>", "Default root account"],
    ["setup-alpine<enter><wait2>", "Setup Alpine"],
    ["${var.locale}<enter><wait2>${var.locale}<enter><wait1>", "Select US keyboard"],
    ["<enter><wait1>", "set default hostname, localhost"],
    ["<enter><wait1>", "set network interface name, eth0"],
    ["<enter><wait2>", "set network dhcp"],
    ["<enter><wait5>", "no manual network config"],
    ["${var.root_password}<enter><wait2>${var.root_password}<enter><wait1>", "set root password"],
    ["<enter><wait5>", "set time zone, UTC"],
    ["<enter><wait5>", "setup proxy, default none"],
    ["<spacebar><wait1><enter><wait5>", "setup repo mirror, default 1"],
    ["<enter><wait1>", "setup user, deafault no"],
    ["<enter><wait1>", "setup ssh server, default openssh"],
    ["<enter><wait1>", "allow ssh root login, deafault prohibit password"],
    ["<enter><wait1>", "ssh root key, deafault prohibit password"],
    ["vda<enter><wait1>sys<enter><wait15>y<enter><wait30>", "setup disk, vda"],
    ["reboot<enter><wait20>", "restart and boot into base image"],
    ["root<enter><wait1>${var.root_password}<enter><wait5>", "log into machine"],
    ["sed -i '/community/s/^#//' /etc/apk/repositories<enter><wait1>", "enable community repo"],
    ["apk upgrade<enter><wait30>", "upgrade packages"],
    ["apk add ${join(" ", local.packages)}<enter><wait60>", "install packages"],
    ["${join("<enter><wait1>", local.services)}<enter><wait1>", "enable services"],
    ["echo 'datasource_list: [ NoCloud ]' > /etc/cloud/cloud.cfg.d/99_nocloud.cfg<enter><wait1>", "set cloud init datasources"],
    ["echo 'isofs' > /etc/modules-load.d/isofs.conf<enter><wait1>", "load iso9660 filesystem to read cloud-init cdrom"], # without this, mount -t auto /dev/sr0 fails
    // ["echo 'RESOLV_CONF=\"no\"' >> /etc/udhcpd.conf<enter><wait1>", "disable overwriting of resolve.conf by udhcpd"],
    ["poweroff<enter>", "shutdown"]
  ]
  communicator = "none"
}

build {
  description = "Build base Alpine Linux ${var.architecture}"

  sources = ["source.qemu.alpine"]
}
