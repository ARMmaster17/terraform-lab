terraform {
  required_providers {
    proxmox = {
        source = "Telmate/proxmox"
        version = "2.7.4"
    }
    phpipam = {
      source = "lord-kyron/phpipam"
      version = "1.2.8"
    }
  }
}

provider "proxmox" {
    pm_api_url = var.proxmox-url
    pm_user = var.proxmox-username
    pm_password = var.proxmox-password
    pm_tls_insecure = "true"
}

provider "phpipam" {
  app_id = "terraform"
  endpoint = var.ipam-url
  password = var.ipam-password
  username = var.ipam-username
  insecure = true
}

module "dns" {
    source = "./modules/dns"

    ns_count = 1
}