variable "image" {
  description = "Droplet image ID or slug"
  type        = string
  default     = "debian-11-x64"
}

variable "name" {
  description = "Name of the droplet"
  type        = string
}

variable "region" {
  description = "Region where the droplet will be created"
  type        = string
  default     = "FRA1" # Frankfurt
}

variable "size" {
  description = "Size of the droplet"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "ssh_keys" {
  description = "List of ssh keys' ids to be setup in the droplet"
  type        = list(string)
}

variable "volumes" {
  description = "List of volumes to create and attach to the droplet"
  type = list(object({
    name       = string
    size       = number # In GiB
    filesystem = string
  }))
}

variable "allowed_ips" {
  description = "List of IPs which are allowed to contact the droplet (all tccp/udp ports)"
  type        = list(string)
  default     = []
}