# secure-provision-pipeline

An end-to-end Infrastructure-as-Code pipeline: Terraform provisions VMs on Proxmox, hands off to Ansible for hardened configuration, and the whole thing runs through GitHub Actions with security scanning gates.

## Architecture

```
GitHub Actions (self-hosted runner on github-runner VM)
        │
        ▼
  terraform apply  ──►  Proxmox (pve01)
        │                    │
        │                    ▼
        │            bastion01 / web01 / db01
        │            (cloned from ubuntu-2404-cloudinit-template)
        │
        ▼
  writes ansible/inventory/dev.yml
        │
        ▼
  ansible-playbook  ──►  configures + hardens each VM
```

## Components

- **`terraform/modules/vm`** — reusable module for provisioning a single VM from the cloud-init template
- **`terraform/environments/dev`** — calls the module three times (bastion01, web01, db01), writes remote state to Azure Storage, and generates the Ansible inventory automatically on `apply`
- **`ansible/`** — roles and playbooks for hardening/configuring each tier
- **`.github/workflows/`** — CI/CD pipeline: security scanning (tfsec/checkov, ansible-lint) → terraform apply → ansible-playbook

## Prerequisites

- Proxmox host with a cloud-init template (`ubuntu-2404-cloudinit-template`, built from Ubuntu 24.04 cloud image)
- Proxmox service account (`terraform@pve`) with a scoped role (not root) and API token
- Self-hosted GitHub Actions runner with network access to the Proxmox host
- Repository secrets: `PROXMOX_API_TOKEN`, `PROXMOX_ENDPOINT`, `SSH_PUBLIC_KEY`, `SSH_PRIVATE_KEY`

## Current network design

All VMs currently run flat on `192.168.1.0/24`, same as the rest of the homelab — `vmbr0` is not presently VLAN-aware.

## Future work

- **Network segmentation**: enable `bridge-vlan-aware` on `vmbr0` and split bastion/web/db onto separate VLANs, with the bastion as the only host reaching the app tier and the db tier isolated from direct edge access
- **Policy-as-code**: OPA/Conftest or Sentinel gating on `terraform plan`
- **Compliance mapping**: CIS Controls / NIST 800-53 mapping doc for each hardening role
- **Drift detection**: scheduled `terraform plan` to catch out-of-band changes
- **Packer**: automate cloud-init template creation instead of building it by hand
