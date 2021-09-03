module "dns_vm" {
    source = "../vm-base"
    
    count = var.ns_count

    ssh_key = var.ssh_key
    ssh_private_key = var.ssh_private_key
    hostname = "ns${count.index + 1}"
    domain = var.domain
    cores = 1
    ram = 1024
    setup_commands = ["sudo apt-get install bind9 bind9utils bind9-doc -y", "ls"]
    # Using https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-caching-or-forwarding-dns-server-on-ubuntu-16-04
}