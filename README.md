<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_mgc"></a> [mgc](#requirement\_mgc) | 0.41.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_mgc"></a> [mgc](#provider\_mgc) | 0.41.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [mgc_network_security_groups.valheim_sg](https://registry.terraform.io/providers/MagaluCloud/mgc/0.41.0/docs/resources/network_security_groups) | resource |
| [mgc_network_security_groups_rules.game_access_rule](https://registry.terraform.io/providers/MagaluCloud/mgc/0.41.0/docs/resources/network_security_groups_rules) | resource |
| [mgc_network_security_groups_rules.http_rule](https://registry.terraform.io/providers/MagaluCloud/mgc/0.41.0/docs/resources/network_security_groups_rules) | resource |
| [mgc_network_security_groups_rules.ssh_rule](https://registry.terraform.io/providers/MagaluCloud/mgc/0.41.0/docs/resources/network_security_groups_rules) | resource |
| [mgc_network_security_groups_rules.supervisor_rule](https://registry.terraform.io/providers/MagaluCloud/mgc/0.41.0/docs/resources/network_security_groups_rules) | resource |
| [mgc_ssh_keys.valheim_key](https://registry.terraform.io/providers/MagaluCloud/mgc/0.41.0/docs/resources/ssh_keys) | resource |
| [mgc_virtual_machine_instances.valheim_server](https://registry.terraform.io/providers/MagaluCloud/mgc/0.41.0/docs/resources/virtual_machine_instances) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | The Magalu Cloud API Key | `string` | n/a | yes |
| <a name="input_mgc_key_pair_id"></a> [mgc\_key\_pair\_id](#input\_mgc\_key\_pair\_id) | The Magalu Cloud key pair id | `string` | n/a | yes |
| <a name="input_mgc_key_pair_secret"></a> [mgc\_key\_pair\_secret](#input\_mgc\_key\_pair\_secret) | The Magalu Cloud key pair secret | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Default region | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_valheim_server_public_ip"></a> [valheim\_server\_public\_ip](#output\_valheim\_server\_public\_ip) | Easy access to the public IP |
<!-- END_TF_DOCS -->