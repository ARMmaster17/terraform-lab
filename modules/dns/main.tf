module "dns_vm" {
    source = "../vm-base"
    
    sys_count = var.ns_count
    hostname = "ns"
    ip_rng = "10.1.40."
    host_id = 1
}