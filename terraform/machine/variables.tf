variable "name" {
  type        = string
  description = "name of virtual machine"
}

variable "hostname" {
  type        = string
  description = "hostname of virtual machine, defaults to value set from var.name"
  default     = null
}

variable "cpus" {
  type        = number
  description = "Number of vCPUs"
  default     = 1
}

variable "memory" {
  type        = number
  description = "Amount of memory in MiB"
  default     = 1028
}

variable "disk_size" {
  type        = number
  description = "disk size in GiB, defaults to 5"
  default     = 5
}

variable "network" {
  type = object({
    network_id = string
    network    = string
    domain     = string
  })
  description = "network"
}

variable "pool_name" {
  type        = string
  description = "Name of pool to use, defaults to 'default'"
  default     = "default"
}

variable "base_image" {
  type        = string
  description = "QEMU qcow2 image to use as the base image"
  default     = null
}

variable "user_data" {
  type        = string
  description = "cloud-init user-data"
  default     = null
}
