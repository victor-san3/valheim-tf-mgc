# Valheim Server on Magalu Cloud (MGC)

This project uses Terraform to deploy a [Valheim](https://www.valheimgame.com/) dedicated game server on Magalu Cloud (MGC). It provisions a Virtual Machine, configures networking and security groups, and bootstraps the server with Docker using a robust cloud-init script.

## Project Overview

The infrastructure consists of:
*   **Provider:** `MagaluCloud/mgc`
*   **Compute:** A virtual machine instance (`BV2-2-10` flavor) running Ubuntu 24.04 LTS.
*   **Networking:**
    *   Public IPv4 address.
    *   Security Group rules allowing:
        *   **SSH (22/tcp):** Remote management.
        *   **HTTP (80/tcp):** Status server (intended).
        *   **Supervisor (9001/tcp):** Dashboard access.
        *   **Game Traffic (2456-2457/udp):** Valheim game ports.
*   **Storage:** Terraform state is stored remotely in an S3-compatible bucket on Magalu Object Storage.
*   **Backups:** Automated 4-hourly backups of the Valheim server data to S3.

## Architecture Highlights

*   **Deferred Startup:** The Valheim Docker container is configured to start via a systemd one-shot service (`valheim-init.service`) *after* the initial system update and reboot. This prevents race conditions and ensures a clean environment.
*   **Automated Sync:** On first boot, the server data is synchronized from an existing S3 bucket (`s3://bird-weak-gray/valheim-server/`).
*   **Automated Updates:** The system performs a full `apt dist-upgrade` and cleanup during provisioning.
*   **Cron Backups:** A cron job is installed for the `ubuntu` user to back up the server every 4 hours.

## Directory Structure

*   `main.tf`: Configures the MGC provider and the S3 backend for state storage.
*   `instance.tf`: Defines the core resources: VM instance, Security Groups, Rules, and SSH Key.
*   `variables.tf`: Declares input variables like `api_key` and `region`.
*   `terraform.tfvars`: (Git-ignored) Contains sensitive variable values.
*   `scripts/init.sh`: User Data script executed on first boot. Handles updates, Docker installation, AWS CLI config, data sync, and service setup.

## Prerequisites

1.  **Terraform:** Installed on your local machine.
2.  **Magalu Cloud Account:** With an active API Key.
3.  **S3 Backend Config:** The `main.tf` is configured to use a remote backend.
4.  **AWS CLI (Optional):** For manual bucket management.

## Configuration

### Variables

Key variables defined in `variables.tf`:
*   `api_key`: Your Magalu Cloud API Key.
*   `region`: The target deployment region (e.g., `br-se1`).
*   `mgc_key_pair_id` / `mgc_key_pair_secret`: Credentials for object storage.

### Secrets
Create a `terraform.tfvars` file to set your secrets. **Do not commit this file.**

```hcl
api_key             = "your-api-key"
region              = "br-se1"
mgc_key_pair_id     = "your-key-id"
mgc_key_pair_secret = "your-key-secret"
```

## Deployment

1.  **Initialize Terraform:**
    ```bash
    terraform init
    ```

2.  **Plan the Deployment:**
    ```bash
    terraform plan
    ```

3.  **Apply Changes:**
    Provision the infrastructure.
    ```bash
    terraform apply
    ```

4.  **Access the Server:**
    After a successful apply, Terraform will output the public IP.
    ```bash
    ssh -i <path-to-private-key> ubuntu@<output_public_ip>
    ```

## Post-Deployment & Maintenance

The `scripts/init.sh` script runs automatically on the first boot. It performs the following sequence:
1.  **Updates:** Full system upgrade (`dist-upgrade`).
2.  **Install:** Docker CE, Docker Compose, AWS CLI, `unzip`.
3.  **Config:** AWS CLI configured with provided credentials.
4.  **Sync:** Downloads Valheim server files from S3.
5.  **Service:** Creates `valheim-init.service` to start Docker after reboot.
6.  **Cron:** Installs `backup_magalu.sh` to run every 4 hours.
7.  **Reboot:** Finalizes updates and starts the game server.

**Monitoring Logs:**
To check the provisioning status:
```bash
tail -f /var/log/user-data.log
```

**Verify Cron:**
```bash
crontab -u ubuntu -l
```
