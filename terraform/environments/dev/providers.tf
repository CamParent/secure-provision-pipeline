terraform {
  required_version = ">= 1.7.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.60"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # Remote state backend in Azure Storage (created 2026-07-23).
  # Auth is via ARM_ACCESS_KEY env var (set from GitHub secret in CI) -
  # the storage account key itself is never written here or committed.
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "camsppstate2026"
    container_name       = "secure-provision-pipeline"
    key                   = "dev.terraform.tfstate"
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_tls_insecure

  ssh {
    agent    = true
    username = "root"
  }
}
