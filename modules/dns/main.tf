module "dns_vm" {
    source = "../vm-base"
    
    count = var.ns_count

    ssh_key = var.ssh_key
    ssh_private_key = var.ssh_private_key
    hostname = "ns${count.index + 1}"
    domain = var.domain
    cores = 1
    ram = 512
    setup_commands = ["ls"]
}