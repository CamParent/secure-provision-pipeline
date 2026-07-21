output "vm_ips" {
  description = "Map of VM name to IP address, for reference/debugging"
  value = {
    bastion01 = module.bastion01.ip_address
    web01     = module.web01.ip_address
    db01      = module.db01.ip_address
  }
}

# --- Terraform -> Ansible handoff ---
# Writes a dynamic-inventory-friendly YAML file straight into ansible/inventory/
# so the next CI job (or you, locally) can run ansible-playbook immediately
# after terraform apply with no manual copy-paste of IPs.
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../ansible/inventory/dev.yml"
  content = templatefile("${path.module}/inventory.tmpl", {
    bastion_ip = module.bastion01.ip_address
    web_ip     = module.web01.ip_address
    db_ip      = module.db01.ip_address
  })
}
