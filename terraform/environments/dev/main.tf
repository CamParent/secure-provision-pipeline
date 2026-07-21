locals {
  ssh_key = var.ssh_public_key
}

module "bastion01" {
  source = "../../modules/vm"

  vm_name        = "bastion01"
  template_name  = "ubuntu-2404-cloudinit-template"
  cores          = 1
  memory         = 1024
  disk_size      = "10G"
  ip_address     = "192.168.1.60/24"
  ssh_public_key = local.ssh_key
  tags           = ["pipeline", "bastion"]
}

module "web01" {
  source = "../../modules/vm"

  vm_name        = "web01"
  template_name  = "ubuntu-2404-cloudinit-template"
  cores          = 2
  memory         = 2048
  disk_size      = "20G"
  ip_address     = "192.168.1.61/24"
  ssh_public_key = local.ssh_key
  tags           = ["pipeline", "web"]
}

module "db01" {
  source = "../../modules/vm"

  vm_name        = "db01"
  template_name  = "ubuntu-2404-cloudinit-template"
  cores          = 2
  memory         = 4096
  disk_size      = "40G"
  ip_address     = "192.168.1.62/24"
  ssh_public_key = local.ssh_key
  tags           = ["pipeline", "db"]
}
