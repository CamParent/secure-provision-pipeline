variable "vm_name" {
  description = "Name of the VM as it will appear in Proxmox"
  type        = string
}

variable "target_node" {
  description = "Proxmox node to provision on"
  type        = string
  default     = "pve01"
}

variable "vmid" {
  description = "Explicit VMID (optional - Proxmox will auto-assign if not set)"
  type        = number
  default     = null
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Disk size, e.g. '20G'"
  type        = string
  default     = "20G"
}

variable "storage_pool" {
  description = "Proxmox storage pool for the disk"
  type        = string
  default     = "local-lvm"
}

variable "template_name" {
  description = "Name of the cloud-init template to clone from"
  type        = string
}

variable "network_bridge" {
  description = "Proxmox network bridge"
  type        = string
  default     = "vmbr0"
}

variable "ip_address" {
  description = "Static IP in CIDR form, e.g. '192.168.1.50/24'"
  type        = string
}

variable "gateway" {
  description = "Network gateway"
  type        = string
  default     = "192.168.1.1"
}

variable "ssh_public_key" {
  description = "SSH public key injected via cloud-init"
  type        = string
}

variable "tags" {
  description = "Proxmox tags for the VM (used for inventory grouping)"
  type        = list(string)
  default     = []
}
