#!/bin/bash
set -e
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Set non-interactive mode for all apt commands
export DEBIAN_FRONTEND=noninteractive

# Function to wait for apt lock
wait_for_apt() {
  while fuser /var/lib/dpkg/lock >/dev/null 2>&1 || fuser /var/lib/apt/lists/lock >/dev/null 2>&1 || fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
    echo "Waiting for apt lock..."
    sleep 5
  done
}

echo "Starting user_data script..."

# 1. Upgrade Ubuntu
wait_for_apt
apt-get update
wait_for_apt
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

# 2. Remove old Docker versions
wait_for_apt
apt-get remove -y docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc || true

# 3. Set up Docker apt repository
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
wait_for_apt
apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu noble stable" > /etc/apt/sources.list.d/docker.list

wait_for_apt
apt-get update

# 4. Install Docker with pinned containerd.io version
# Pinning to 2.2.0-2 to work around Docker's broken package index (2.2.1 advertised but not on CDN)
CONTAINERD_VERSION="2.2.0-2~ubuntu.24.04~noble"
wait_for_apt
apt-get install -y \
  containerd.io=$${CONTAINERD_VERSION} \
  docker-ce \
  docker-ce-cli \
  docker-buildx-plugin \
  docker-compose-plugin \
  unzip \
  btop

# 5. Post-install steps
groupadd docker || true
usermod -aG docker ubuntu
timedatectl set-timezone America/Sao_Paulo

# 6. Create 2GB swap file to prevent OOM kills
echo "Creating swap file..."
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
# Lower swappiness to only use swap under pressure
echo 'vm.swappiness=10' >> /etc/sysctl.conf
sysctl -p

# 7. Install Netdata for real-time monitoring
echo "Installing Netdata..."
curl https://get.netdata.cloud/kickstart.sh > /tmp/netdata-kickstart.sh
bash /tmp/netdata-kickstart.sh --stable-channel --non-interactive

# Hold containerd.io to prevent upgrade to broken 2.2.1 version
apt-mark hold containerd.io

# Run test as docker group without switching shells
sudo -u ubuntu sg docker -c "docker run hello-world"

# 6. Install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/home/ubuntu/awscliv2.zip"
unzip /home/ubuntu/awscliv2.zip -d /home/ubuntu
sudo /home/ubuntu/aws/install
rm -rf /home/ubuntu/aws /home/ubuntu/awscliv2.zip

# 6. Configure AWS CLI
sudo -u ubuntu aws configure set aws_access_key_id "${mgc_key_pair_id}"
sudo -u ubuntu aws configure set aws_secret_access_key "${mgc_key_pair_secret}"
sudo -u ubuntu aws configure set default.region "${region}"

# 7. Download Valheim Server Directory
sudo -u ubuntu mkdir -p /home/ubuntu/valheim-server/
sudo -u ubuntu aws s3 sync s3://bird-weak-gray/valheim-server/ /home/ubuntu/valheim-server/ --endpoint-url https://br-se1.magaluobjects.com

# 8. Configure Systemd One-Shot Service for First Boot Start
# This ensures Docker starts the container AFTER the system reboot, preventing corruption.
cat <<EOF > /etc/systemd/system/valheim-init.service
[Unit]
Description=Start Valheim Server on First Boot
After=docker.service network-online.target
Wants=docker.service network-online.target

[Service]
Type=oneshot
User=ubuntu
WorkingDirectory=/home/ubuntu/valheim-server
ExecStart=/usr/bin/docker compose up -d
ExecStartPost=/usr/bin/systemctl disable valheim-init.service
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Enable the service so it runs on reboot
systemctl enable valheim-init.service

# 9. Configure Backup Cron Job
chmod +x /home/ubuntu/valheim-server/cron/backup_magalu.sh
echo "15 */1 * * * /home/ubuntu/valheim-server/cron/backup_magalu.sh" >> /var/spool/cron/crontabs/ubuntu
chown ubuntu:crontab /var/spool/cron/crontabs/ubuntu
chmod 600 /var/spool/cron/crontabs/ubuntu

# 10. Final System Update & Cleanup
echo "Performing final update and cleanup..."
wait_for_apt
apt-get update
wait_for_apt
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
wait_for_apt
apt-get autoremove -y
apt-get clean -y
echo "User data script completed successfully. Rebooting..."
reboot

