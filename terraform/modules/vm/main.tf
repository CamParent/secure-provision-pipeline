resource "proxmox_virtual_environment_vm" "this" {
  name      = var.vm_name
  node_name = var.target_node
  vm_id     = var.vmid
  tags      = var.tags

  clone {
    node_name = var.target_node
    vm_id     = data.proxmox_virtual_environment_vms.template.vms[0].vm_id
    full      = true
  }

  cpu {
    cores = var.cores
    type  = "host"
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.storage_pool
    interface    = "scsi0"
    size         = tonumber(replace(var.disk_size, "G", ""))
  }

  network_device {
    bridge = var.network_bridge
    # No vlan_id set - vmbr0 is not currently VLAN-aware (flat /24, same as
    # existing lab VMs). Segmentation is a documented future upgrade - see
    # README "Future Work" section.
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }

    user_account {
      keys = [var.ssh_public_key]
    }
  }

  # Ensures cloud-init has finished before Ansible tries to connect
  provisioner "remote-exec" {
    inline = ["cloud-init status --wait"]

    connection {
      type        = "ssh"
      host        = split("/", var.ip_address)[0]
      user        = "ansible"
      private_key = file(pathexpand("~/.ssh/id_ed25519_spp"))
    }
  }
}

data "proxmox_virtual_environment_vms" "template" {
  filter {
    name   = "name"
    values = [var.template_name]
  }
}
