# Vault KV Mount Terraform module

This module provisions a KVv2 secret engine mount in Vault.

## Permissions

Required access for the Vault caller identity:

- Create and manage mounts at the configured path.

## Authentications

Authentication to Vault can be configured in the caller using one of these methods:

### Static token

- `VAULT_ADDR`: Vault cluster address.
- `VAULT_NAMESPACE`: Target Vault namespace (for HCP Vault Dedicated).
- `VAULT_TOKEN`: Vault token with required capabilities.

### HCP Terraform dynamic credentials

- `TFC_VAULT_PROVIDER_AUTH=true`
- `TFC_VAULT_ADDR`
- `TFC_VAULT_NAMESPACE`
- `TFC_VAULT_AUTH_PATH`
- `TFC_VAULT_RUN_ROLE`

## Features

- Creates one KVv2 mount used by both VSO and VSO+CSI lanes.

## Usage example

```hcl
module "vault_kv_mount" {
  source = "./modules/vault-kv-mount"

  mount_path = "kvv2"
}
```

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_vault"></a> [vault](#requirement\_vault) (5.8.0)

## Providers

The following providers are used by this module:

- <a name="provider_vault"></a> [vault](#provider\_vault) (5.8.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [vault_mount.kvv2](https://registry.terraform.io/providers/hashicorp/vault/5.8.0/docs/resources/mount) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_mount_path"></a> [mount\_path](#input\_mount\_path)

Description: (Required) Vault KVv2 mount path to create once for demo secret storage.

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_mount_path"></a> [mount\_path](#output\_mount\_path)

Description: KVv2 mount path created by this module.
