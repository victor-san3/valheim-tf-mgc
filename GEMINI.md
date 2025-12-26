# Valheim Server Deployment

This project uses Terraform to deploy a [Valheim](https://www.valheimgame.com/) dedicated game server. It supports multiple deployment targets:

| Target | Directory | Status |
|--------|-----------|--------|
| **Magalu Cloud (MGC)** | `mgc/` | ✅ Production |
| **Proxmox VE (PVE)** | `pve/` | 🚧 Coming Soon |

## Directory Structure

```
valheim-tf/
├── mgc/                    # MGC deployment
│   ├── main.tf             # Provider + S3 backend
│   ├── instance.tf         # VM, security groups, SSH key
│   ├── cloudflare.tf       # DNS record
│   ├── variables.tf        # Input variables
│   └── scripts/init.sh     # Cloud-init script
├── pve/                    # PVE deployment (placeholder)
└── .github/workflows/
    ├── deploy-mgc.yml
    ├── undeploy-mgc.yml
    ├── deploy-pve.yml      # Placeholder
    └── undeploy-pve.yml    # Placeholder
```

## Shared Infrastructure

*   **State Backend:** Both targets use the same S3 bucket (`terraform-tf-state`) with isolated keys (`mgc/terraform.tfstate`, `pve/terraform.tfstate`).
*   **DNS:** Cloudflare manages `valheim.sanchez.dev.br` for whichever deployment is active.

---

## MGC Deployment

### Prerequisites

1.  **Terraform:** Installed on your local machine.
2.  **Magalu Cloud Account:** With an active API Key.
3.  **Cloudflare Account:** Zone ID and API Token with DNS edit permissions.

### Secrets

Create `mgc/terraform.tfvars`:
```hcl
api_key              = "your-api-key"
region               = "br-se1"
mgc_key_pair_id      = "your-key-id"
mgc_key_pair_secret  = "your-key-secret"
cloudflare_api_token = "your-cf-token"
cloudflare_zone_id   = "your-cf-zone-id"
```

### Local Deployment

```bash
cd mgc
terraform init
terraform apply
```

### GitHub Actions

1.  Configure secrets in **Settings > Secrets and variables > Actions**:
    *   `MGC_API_KEY`, `MGC_KEY_PAIR_ID`, `MGC_KEY_PAIR_SECRET`
    *   `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ZONE_ID`

2.  Run **Deploy Valheim Server (MGC)** from the Actions tab.

---

## PVE Deployment

Coming soon. Will use the `bpg/proxmox` Terraform provider to deploy to a 3-node Proxmox VE cluster.
