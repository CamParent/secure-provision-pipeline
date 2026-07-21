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

  # Remote state backend - create this storage account/container first with:
  #   az group create -n tfstate-rg -l eastus
  #   az storage account create -n <uniquestorageacct> -g tfstate-rg -l eastus --sku Standard_LRS
  #   az storage container create -n secure-provision-pipeline --account-name <uniquestorageacct>
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "" # fill in - keep out of source control, pass via -backend-config
    container_name        = "secure-provision-pipeline"
    key                    = "dev.terraform.tfstate"
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
