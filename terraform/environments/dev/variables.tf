variable "proxmox_endpoint" {
  description = "Proxmox API endpoint, e.g. https://192.168.1.10:8006/"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token in 'user@realm!tokenid=uuid' format"
  type        = string
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  description = "Skip TLS verification (true for self-signed homelab certs)"
  type        = bool
  default     = true
}

variable "ssh_public_key" {
  description = "SSH public key to inject into all VMs"
  type        = string
}
