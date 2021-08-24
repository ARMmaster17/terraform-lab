variable "ns_count" {
    type = number
    default = 1
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