module "dns_vm" {
  source = "../vm-base"

  count = var.node_count

  ssh_key = var.ssh_key
  ssh_private_key = var.ssh_private_key
  hostname = "k3s-${var.cluster_name}-n${count.index + 1}"
  domain = var.domain
  cores = 1
  ram = 1024
  setup_commands = [
    "sleep 1" # For now, setup is done externally with k3sup
  ]
}