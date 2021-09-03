variable "cluster_name" {
  type = string
  default = "default"
}

variable "ssh_key" {
  type = string
  sensitive = true
}

variable "ssh_private_key" {
  type = string
  sensitive = true
}

variable "domain" {
  type = string
  default = "gen2.firecore.lab"
}

variable "node_count" {
  type = number
  default = 1
}