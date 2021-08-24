variable "proxmox-username" {
    type = string
    sensitive = true
}

variable "proxmox-password" {
    type = string
    sensitive = true
}

variable "proxmox-url" {
    type = string
    sensitive = true
}

variable "ipam-url" {
    type = string
    sensitive = true
}

variable "ipam-username" {
    type = string
    sensitive = true
}

variable "ipam-password" {
    type = string
    sensitive = true
}

variable "ssh_key" {
    type = string
    sensitive = true
}

variable "ssh_private_key" {
    type = string
    sensitive = true
}