module "dns_vm" {
  source = "../vm-base"

  count = var.node_count

  ssh_key = var.ssh_key
  ssh_private_key = var.ssh_private_key
  hostname = "k3s-${var.cluster_name}-n${count.index + 1}"
  domain = var.domain
  cores = 1
  ram = 1024
  setup_commands = ["sudo apt-get install bind9 bind9utils bind9-doc -y", "ls"]
  # Use k3sup?
}