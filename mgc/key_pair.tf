resource "tls_private_key" "ed25519_valheim_server" {
  algorithm = "ED25519"
}

resource "mgc_ssh_keys" "valheim_key" {
  name = "valheim-key"
  key  = tls_private_key.ed25519_valheim_server.public_key_openssh
}

output "ed25519_valheim_server_public_key" {
  value = tls_private_key.ed25519_valheim_server.public_key_openssh
}

output "ed25519_valheim_server_private_key" {
  value = tls_private_key.ed25519_valheim_server.private_key_openssh
}