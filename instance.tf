resource "mgc_network_security_groups" "valheim_sg" {
  name        = "lloesche-valheim-server"
  description = "Security group for Valheim Server access and Supervisor dashboard access."
}

# SSH rule
resource "mgc_network_security_groups_rules" "ssh_rule" {
  description       = "Allow SSH access"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.valheim_sg.id
}

# HTTP rule
resource "mgc_network_security_groups_rules" "http_rule" {
  description       = "Allow HTTP access for status server"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 80
  port_range_max    = 80
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.valheim_sg.id
}

# Supervisor rule
resource "mgc_network_security_groups_rules" "supervisor_rule" {
  description       = "Allow HTTP custom port access for supervisor server"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 9001
  port_range_max    = 9001
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.valheim_sg.id
}

# Game access rule
resource "mgc_network_security_groups_rules" "game_access_rule" {
  description       = "Allow UDP access on default Valheim ports"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 2456
  port_range_max    = 2457
  protocol          = "udp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.valheim_sg.id
}

# Creat SSH key
resource "mgc_ssh_keys" "valheim_key" {
  name = "valheim-key"
  key  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKo3gtP4MPg5jcqZtZbtfl7w7i/wiwrzqbzeMv14ebj mgc_terrafor_valheim_key"
}

# Create VM with custom security groups and public IP
resource "mgc_virtual_machine_instances" "valheim_server" {
  name                     = "valheim"
  machine_type             = "BV2-2-10"
  image                    = "cloud-ubuntu-24.04 LTS"
  ssh_key_name             = mgc_ssh_keys.valheim_key.name
  creation_security_groups = [mgc_network_security_groups.valheim_sg.id]
  allocate_public_ipv4     = true
  user_data = base64encode(templatefile("${path.module}/scripts/init.sh", {
    mgc_key_pair_id     = var.mgc_key_pair_id
    mgc_key_pair_secret = var.mgc_key_pair_secret
    region              = var.region
  }))

}

# Easy access to the public IP
output "valheim_server_public_ip" {
  value = mgc_virtual_machine_instances.valheim_server.ipv4
}
