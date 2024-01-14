## Requirements


- `libvirt`
- `mkisofs`
- `terraform` >= `1.6.5`
- `packer` >= `1.9.4`
- `python` >= `3.11`

### Installing Requirements

#### `qemu/kvm` permissions

AppArmor has policies that block `kvm` from accessing volumes created by `qemu`. Add `/var/lib/libvirt/images/**.qcow2 rwk,` within the profile block.

Example:
```shell
#
# This profile is for the domain whose UUID matches this file.
#

#include <tunables/global>

profile LIBVIRT_TEMPLATE flags=(attach_disconnected) {
  #include <abstractions/libvirt-qemu>
  /var/lib/libvirt/images/**.qcow2 rwk,
}

```

This allows `rw` (read/write) and `k` (lock) access to `.qcow2` files in `/var/lib/libvirt/images/`.

#### Name Resolution

With `systemd-resolved`, `libvirt` cannot update the network configuration to identify the new domain and network to the interface. We want to add a hook to the `libvirt` network process.

Copy the contents of `scripts/network` in this repository to `/etc/libvirt/hooks/network`. If the file does not exist, you can create it. If it does exist, you can append the contents to the file.

## Tasks

| task | description |
| ---:|:--- |
| `pkr:alpine` | create the Alpine Cloud-init image |
| `tf:plan` | Show the current terraform changes |
| `tf:apply` | Apply the current terraform changes |

## Troubleshooting

**Issue:** `clout-init`` fails to mount `/dev/sr0`
**Resolution:** add `isofs` to `/etc/modules-loud.d/isofs.conf`
**Reason:** `clount-init` runs `mount -o ro -t auto /dev/sr0 ...`. If file system `iso9660` is not compiled with the kernel, it will not load until first use. `mount` reads `/proc/filesystem` with using the `auto` type. If `iso9660` is not loaded, it will fail to detect the filesystem.

---
**Issue:** Gust VM not reachable from host by FQDN
**Resolution:** Validate you have the `scripts/network` contents added to `/etc/libvirt/hooks/network`

---
**Issue:** bridge network removed from virt-manager but not from OS
**Resolution:** `sudo ip link delete [interface]`
