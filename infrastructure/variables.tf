variable "prefix" {
  default = "Gitlab-infra"
  type    = string
}

variable "location" {
  description = "Region of the infra resources"
  default     = "West Europe"
  type        = string
}

variable "admin_user" {
  description = "VMs local admin user"
  default     = "mozennou"
  type        = string
}

variable "ssh_pub_key_file" {
  default = "~/.ssh/id_rsa.pub"
  type    = string
}