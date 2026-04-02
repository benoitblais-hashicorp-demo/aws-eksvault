# AWS EKS with Vault VSO and VSO+CSI Demo



## What This Demo Demonstrates



## Demo Components



## Permissions

### AWS



### Vault

Terraform identity for Vault provider must be able to manage:

- Vault policy
- Vault auth role or token suitable for automation
- Certificate issuance from an existing Vault PKI mount and PKI role

The automation token is expected to be scoped to:

- `update` on `/<pki_mount>/issue/<pki_role>`

## Authentications

### AWS



### Vault Authentication

Terraform `vault` provider uses dynamic credentials from environment variables (for example HCP Terraform dynamic credentials), not a hardcoded token in code.

The renewal automation authenticates to Vault using runbook variables and AppRole.

Required runbook Vault values:

- `VAULT_ADDR`
- `VAULT_NAMESPACE` (required in this module)
- `VAULT_AUTH_PATH`
- `VAULT_APPROLE_ROLE_ID`
- `VAULT_APPROLE_SECRET_ID`
- `VAULT_PKI_PATH`
- `VAULT_PKI_ROLE`

## Features



## How Authentication and Secret management work in this Demo



### The Workflow



## Prerequisite

