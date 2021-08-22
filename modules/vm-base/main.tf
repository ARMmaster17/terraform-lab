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

resource "phpipam_address" "newip" {
  subnet_id   = data.phpipam_subnet.subnet.subnet_id
  ip_address  = data.phpipam_first_free_address.next_address.ip_address
  hostname    = "${var.hostname}.${var.domain}"
  description = "Managed by Terraform"

  lifecycle {
    ignore_changes = [
      subnet_id,
      ip_address,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm" {
    count             = var.sys_count
    name              = "${var.hostname}.${var.domain}"
    target_node       = "pxvh${var.host_id}"
    clone             = "ubuntu-1804LTS-template"
    os_type           = "ubuntu"
    cores             = var.cores
    sockets           = "1"
    cpu               = "kvm64"
    memory            = var.ram
    agent = 1
    guest_agent_ready_timeout = 60
    clone_wait = 60
    additional_wait = 120
    ci_wait = 60

    scsihw            = "virtio-scsi-pci"
    bootdisk          = "scsi1"
    network {
        model           = "virtio"
        bridge          = "internal"
    }
    lifecycle {
        ignore_changes  = [
            network,
        ]
    }
    # Cloud Init Settings
    ipconfig0 = "ip=${data.phpipam_first_free_address.next_address.ip_address}/${data.phpipam_subnet.subnet.subnet_mask},gw=10.1.0.1"
    ciuser = var.username
    cipassword = var.cipassword
    sshkeys = <<-EOF
    ${var.ssh_key}
    EOF
    nameserver = "192.168.1.152"

    ssh_user = var.username
    ssh_private_key = var.ssh_private_key

    connection {
      type = "ssh"
      user = var.username
      private_key = var.ssh_private_key
      host = "${data.phpipam_first_free_address.next_address.ip_address}"
      port = 22
    }

    provisioner "remote-exec" {
      inline = concat([
                "sudo apt-get update",
                "sudo apt-get install qemu-guest-agent -y",
                "sudo service qemu-guest-agent start"
            ],
            var.setup_commands
        )
    }
}