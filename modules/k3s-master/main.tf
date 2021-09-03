module "k3s_master_vm" {
  source = "../vm-base"

  count = 1

  ssh_key = var.ssh_key
  ssh_private_key = var.ssh_private_key
  hostname = "k3s-${var.cluster_name}-m1"
  domain = var.domain
  cores = 1
  ram = 2048
  setup_commands = [
    "sudo apt-get install bind9 bind9utils bind9-doc -y",
    ""
  ]
  # Use k3sup here?
}