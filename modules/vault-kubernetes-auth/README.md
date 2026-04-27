<!-- markdownlint-disable MD024 -->
# Vault Kubernetes Auth Terraform module

This module configures Vault Kubernetes authentication and role-based policies for the EKS demo clusters used by VSO and optional CSI integration.

## Permissions

Required access for the Vault caller identity:

- Enable and configure auth methods at the target auth path.
- Create and update Kubernetes auth backend configuration.
- Create and update ACL policies.
- Create and update Kubernetes auth roles.
- Read access to an existing KVv2 mount path (created in the Vault baseline repository).

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

- Configures one Kubernetes auth backend per EKS lane.
- Creates a VSO role bound to the VSO service account.
- Optionally creates a CSI role bound to the CSI service account.
- Creates least-privilege KVv2 read policies for both roles.
- Uses the KVv2 mount path configured by the stack-level one-time mount component.

## Usage example

```hcl
module "vault_kubernetes_auth" {
  source = "./modules/vault-kubernetes-auth"

  cluster_name                       = "eks-ca-vso"
  cluster_endpoint                   = "https://XXXXXXXX.gr7.ca-central-1.eks.amazonaws.com"
  cluster_certificate_authority_data = "BASE64_CA_DATA"
  token_reviewer_jwt                 = "TOKEN_REVIEWER_JWT"
  auth_path                          = "kubernetes-vso-ca-central-1"
  vso_namespace                      = "vault-secrets-operator"
  vso_service_account_name           = "vault-secrets-operator-controller-manager"
}
```

## Documentation

## Requirements

The following requirements are needed by this module:

- terraform (~> 1.14)

- vault (~> 5.8)

## Resources

The following resources are used by this module:

- [vault_auth_backend.kubernetes](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/auth_backend) (resource)
- [vault_kubernetes_auth_backend_config.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kubernetes_auth_backend_config) (resource)
- [vault_kubernetes_auth_backend_role.csi](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kubernetes_auth_backend_role) (resource)
- [vault_kubernetes_auth_backend_role.vso](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kubernetes_auth_backend_role) (resource)
- [vault_policy.csi](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) (resource)
- [vault_policy.vso](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) (resource)

## Required Inputs

The following input variables are required:

### auth_path

Description: (Required) Vault auth mount path for the Kubernetes auth backend.

Type: `string`

### cluster_certificate_authority_data

Description: (Required) Base64-encoded Kubernetes cluster CA certificate.

Type: `string`

### cluster_endpoint

Description: (Required) Kubernetes API endpoint URL used by Vault token review.

Type: `string`

### cluster_name

Description: (Required) Cluster name used for policy naming.

Type: `string`

### token_reviewer_jwt

Description: (Required) JWT token used by Vault to call Kubernetes TokenReview API.

Type: `string`

### vso_namespace

Description: (Required) Namespace containing Vault Secrets Operator workloads.

Type: `string`

### vso_service_account_name

Description: (Required) Service account name bound to the VSO Vault role.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### csi_role_name

Description: (Optional) Vault Kubernetes auth role name for CSI workloads.

Type: `string`

Default: `"vso-csi-role"`

### csi_service_account_name

Description: (Optional) Service account name bound to the CSI Vault role.

Type: `string`

Default: `"vault-csi-provider"`

### csi_service_account_namespace

Description: (Optional) Namespace of the CSI service account bound to the CSI Vault role.

Type: `string`

Default: `"kube-system"`

### enable_csi_role

Description: (Optional) Whether to create a dedicated Vault Kubernetes auth role for CSI.

Type: `bool`

Default: `false`

### kv_mount_path

Description: (Optional) KVv2 mount path containing demonstration secrets.

Type: `string`

Default: `"kvv2"`

### secret_path_prefix

Description: (Optional) Secret path prefix under KVv2 for role policies.

Type: `string`

Default: `"demo"`

### token_max_ttl

Description: (Optional) Maximum token TTL in seconds for Kubernetes auth roles.

Type: `number`

Default: `3600`

### token_ttl

Description: (Optional) Default token TTL in seconds for Kubernetes auth roles.

Type: `number`

Default: `1200`

### vso_role_name

Description: (Optional) Vault Kubernetes auth role name for VSO workloads.

Type: `string`

Default: `"vso-role"`

## Outputs

The following outputs are exported:

### auth_path

Description: Kubernetes auth backend path configured in Vault.

### csi_role_name

Description: CSI Vault role name when enabled.

### kv_mount_path

Description: KVv2 mount path used by Vault policies.

### vso_role_name

Description: VSO Vault role name.
