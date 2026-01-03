resource "tls_private_key" "ed25519_valheim_server" {
  algorithm = "ED25519"
}

resource "mgc_ssh_keys" "valheim_key" {
  name = "valheim-key"
  key  = tls_private_key.ed25519_valheim_server.public_key_openssh
}

output "valheim_private_key" {
  description = "Private SSH key for the Valheim server (use: terraform output -raw valheim_private_key > ~/.ssh/valheim_key)"
  value       = tls_private_key.ed25519_valheim_server.private_key_openssh
  sensitive   = true
}