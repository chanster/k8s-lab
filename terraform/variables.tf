variable "hosts" {
  type        = number
  description = "Number of machines"
}

variable "network_cidr" {
  type = string
}

variable "network_domain" {
  type = string
}

variable "bridge" {
  type = string
}

variable "name" {
  type        = string
  description = "name of virtual machine"
}

variable "hostname" {
  type        = string
  description = "hostname of virtual machine, defaults to value set from var.name"
  default     = null
}

variable "disk_size" {
  type        = number
  description = "disk size in GiB, defaults to 5"
  default     = 5
}

variable "pool_name" {
  type        = string
  description = "Name of pool to use, defaults to 'default'"
  default     = "default"
}

variable "cpus" {
  type        = number
  description = "Number of vCPUs"
  default     = 1
}

variable "ssh_key" {
  type    = string
  default = null
}
