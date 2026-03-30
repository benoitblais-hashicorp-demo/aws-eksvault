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

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_vault"></a> [vault](#requirement\_vault) (5.8.0)

## Providers

The following providers are used by this module:

- <a name="provider_vault"></a> [vault](#provider\_vault) (5.8.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [vault_auth_backend.kubernetes](https://registry.terraform.io/providers/hashicorp/vault/5.8.0/docs/resources/auth_backend) (resource)
- [vault_kubernetes_auth_backend_config.this](https://registry.terraform.io/providers/hashicorp/vault/5.8.0/docs/resources/kubernetes_auth_backend_config) (resource)
- [vault_kubernetes_auth_backend_role.csi](https://registry.terraform.io/providers/hashicorp/vault/5.8.0/docs/resources/kubernetes_auth_backend_role) (resource)
- [vault_kubernetes_auth_backend_role.vso](https://registry.terraform.io/providers/hashicorp/vault/5.8.0/docs/resources/kubernetes_auth_backend_role) (resource)
- [vault_policy.csi](https://registry.terraform.io/providers/hashicorp/vault/5.8.0/docs/resources/policy) (resource)
- [vault_policy.vso](https://registry.terraform.io/providers/hashicorp/vault/5.8.0/docs/resources/policy) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_auth_path"></a> [auth\_path](#input\_auth\_path)

Description: (Required) Vault auth mount path for the Kubernetes auth backend.

Type: `string`

### <a name="input_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#input\_cluster\_certificate\_authority\_data)

Description: (Required) Base64-encoded Kubernetes cluster CA certificate.

Type: `string`

### <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint)

Description: (Required) Kubernetes API endpoint URL used by Vault token review.

Type: `string`

### <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name)

Description: (Required) Cluster name used for policy naming.

Type: `string`

### <a name="input_token_reviewer_jwt"></a> [token\_reviewer\_jwt](#input\_token\_reviewer\_jwt)

Description: (Required) JWT token used by Vault to call Kubernetes TokenReview API.

Type: `string`

### <a name="input_vso_namespace"></a> [vso\_namespace](#input\_vso\_namespace)

Description: (Required) Namespace containing Vault Secrets Operator workloads.

Type: `string`

### <a name="input_vso_service_account_name"></a> [vso\_service\_account\_name](#input\_vso\_service\_account\_name)

Description: (Required) Service account name bound to the VSO Vault role.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_csi_role_name"></a> [csi\_role\_name](#input\_csi\_role\_name)

Description: (Optional) Vault Kubernetes auth role name for CSI workloads.

Type: `string`

Default: `"vso-csi-role"`

### <a name="input_csi_service_account_name"></a> [csi\_service\_account\_name](#input\_csi\_service\_account\_name)

Description: (Optional) Service account name bound to the CSI Vault role.

Type: `string`

Default: `"vault-csi-provider"`

### <a name="input_csi_service_account_namespace"></a> [csi\_service\_account\_namespace](#input\_csi\_service\_account\_namespace)

Description: (Optional) Namespace of the CSI service account bound to the CSI Vault role.

Type: `string`

Default: `"kube-system"`

### <a name="input_enable_csi_role"></a> [enable\_csi\_role](#input\_enable\_csi\_role)

Description: (Optional) Whether to create a dedicated Vault Kubernetes auth role for CSI.

Type: `bool`

Default: `false`

### <a name="input_kv_mount_path"></a> [kv\_mount\_path](#input\_kv\_mount\_path)

Description: (Optional) KVv2 mount path containing demonstration secrets.

Type: `string`

Default: `"kvv2"`

### <a name="input_secret_path_prefix"></a> [secret\_path\_prefix](#input\_secret\_path\_prefix)

Description: (Optional) Secret path prefix under KVv2 for role policies.

Type: `string`

Default: `"demo"`

### <a name="input_token_max_ttl"></a> [token\_max\_ttl](#input\_token\_max\_ttl)

Description: (Optional) Maximum token TTL in seconds for Kubernetes auth roles.

Type: `number`

Default: `3600`

### <a name="input_token_ttl"></a> [token\_ttl](#input\_token\_ttl)

Description: (Optional) Default token TTL in seconds for Kubernetes auth roles.

Type: `number`

Default: `1200`

### <a name="input_vso_role_name"></a> [vso\_role\_name](#input\_vso\_role\_name)

Description: (Optional) Vault Kubernetes auth role name for VSO workloads.

Type: `string`

Default: `"vso-role"`

## Outputs

The following outputs are exported:

### <a name="output_auth_path"></a> [auth\_path](#output\_auth\_path)

Description: Kubernetes auth backend path configured in Vault.

### <a name="output_csi_role_name"></a> [csi\_role\_name](#output\_csi\_role\_name)

Description: CSI Vault role name when enabled.

### <a name="output_kv_mount_path"></a> [kv\_mount\_path](#output\_kv\_mount\_path)

Description: KVv2 mount path used by Vault policies.

### <a name="output_vso_role_name"></a> [vso\_role\_name](#output\_vso\_role\_name)

Description: VSO Vault role name.
