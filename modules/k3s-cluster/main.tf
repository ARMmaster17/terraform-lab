module "primary" {
  source = "../k3s-master"

  cluster_name = var.cluster_name
  domain = var.domain
  ssh_key = var.ssh_key
  ssh_private_key = var.ssh_private_key
}

module "secondary" {
  source = "../k3s-node"

  node_count = var.node_count - 1
  cluster_name = var.cluster_name
  domain = var.domain
  ssh_key = var.ssh_key
  ssh_private_key = var.ssh_private_key

  depends_on = [
    module.primary
  ]
}