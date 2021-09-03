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

resource "random_password" "cipassword" {
  length = 16
  special = false
}

resource "random_integer" "node_id" {
  min = 1
  max = 3
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
    count             = 1
    name              = "${var.hostname}.${var.domain}"
    target_node       = "pxvh${random_integer.node_id.result}"
    clone             = "ubuntu-2004-cloudinit-qemu-template"
    desc              = "Managed by Terraform"
    os_type           = "ubuntu"
    cores             = var.cores
    sockets           = "1"
    cpu               = "kvm64"
    memory            = var.ram
    agent = 1
    clone_wait = 15
    additional_wait = 0
    ci_wait = 120

    scsihw            = "virtio-scsi-pci"
    bootdisk          = "scsi0"
    network {
        model           = "virtio"
        bridge          = "internal"
        firewall        = "false"
    }
    lifecycle {
        ignore_changes  = [
            target_node,
            network,
        ]
    }
    # Cloud Init Settings
    ipconfig0 = "ip=${data.phpipam_first_free_address.next_address.ip_address}/${data.phpipam_subnet.subnet.subnet_mask},gw=10.1.0.1"
    ciuser = "ubuntu"
    cipassword = random_password.cipassword.result
    sshkeys = <<-EOF
    ${var.ssh_key}
    EOF
    nameserver = "192.168.1.152"

    ssh_user = "ubuntu"
    ssh_private_key = var.ssh_private_key

    provisioner "remote-exec" {
      inline = concat([
                "/bin/bash while [ test -f /var/lib/dpkg/lock-frontend ]; do sleep 1; done",
                "sudo apt-get update"
            ],
            var.setup_commands
        )
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = var.ssh_private_key
        host = "${data.phpipam_first_free_address.next_address.ip_address}"
        port = 22
      }
    }
}
