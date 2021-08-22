variable "ssh_key" {
    type = string
    sensitive = true
}

variable "ssh_private_key" {
    type = string
    sensitive = true
}

variable "sys_count" {
    type = number
    default = 1
}

variable "hostname" {
    type = string
    default = "default"
}

variable "domain" {
    type = string
    default = "gen2.firecore.lab"
}

variable "cores" {
    type = number
    default = 1
}

variable "ram" {
    type = number
    default = 512
}

variable "username" {
    type = string
}

variable "cipassword" {
    type = string
    sensitive = true
}

variable "setup_commands" {
    type = list(string)
    default = []
}

variable "host_id" {
    type = number
    default = 1
}

data "phpipam_subnet" "subnet" {
  subnet_address = "10.1.0.0"
  subnet_mask    = 24
}

data "phpipam_first_free_address" "next_address" {
  subnet_id = data.phpipam_subnet.subnet.subnet_id
}