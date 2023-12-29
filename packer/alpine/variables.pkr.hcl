variable "base_url" {
  type        = string
  default     = "https://dl-cdn.alpinelinux.org/alpine"
  description = "Base URL for the alpine image download. This value should not be changed."
}

variable "version" {
  type        = string
  default     = "3.18.5"
  description = "Alpine release version"
}

variable "repository" {
  type        = string
  default     = "releases"
  description = "Alpine repository to use. Availabe values are 'releases' (default), 'community' and 'main'."
  validation {
    condition     = contains(["community", "main", "releases"], var.repository) == true
    error_message = "Not a supported repository."
  }
}

variable "architecture" {
  type        = string
  default     = "x86_64"
  description = "CPU architecture to target. Defaults to x86_64."
  validation {
    condition     = contains(["aarch64", "armv7", "x86_64", "x86"], var.architecture) == true
    error_message = "Architecture is not a supported type."
  }
}

variable "root_password" {
  type = string
}

variable "locale" {
  type = string
  default = "us"
}
