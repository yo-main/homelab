variable "service_account_id" {
  type = string
}

variable "description" {
  type = string
}

variable "roles" {
  type = list(string)
}

variable "role_members" {
  type = string
}