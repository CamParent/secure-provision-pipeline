output "vm_name" {
  value = proxmox_virtual_environment_vm.this.name
}

output "vm_id" {
  value = proxmox_virtual_environment_vm.this.vm_id
}

output "ip_address" {
  value = split("/", var.ip_address)[0]
}

output "tags" {
  value = var.tags
}
