resource "cloudflare_record" "valheim" {
  zone_id         = var.cloudflare_zone_id
  name            = "valheim"
  content         = mgc_virtual_machine_instances.valheim_server.ipv4
  type            = "A"
  ttl             = 300
  proxied         = false
  allow_overwrite = true
}

output "valheim_dns_record" {
  value       = "${cloudflare_record.valheim.name}.${var.cloudflare_zone_id}"
  description = "DNS record for Valheim server"
}
