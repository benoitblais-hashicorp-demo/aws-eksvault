# Kubernetes Demo App Terraform module

This module deploys a VSO-backed demo web application where values are sourced from Vault KVv2 and synced into Kubernetes secrets.

## Permissions

Required permissions for the caller identity:

- Kubernetes RBAC permissions in the target namespace for `deployments`, `services`, `ingresses`, and `secrets.hashicorp.com` custom resources (`VaultConnection`, `VaultAuth`, `VaultStaticSecret`).
- Vault permissions to write/read KVv2 secrets under the configured mount and path prefix.

The module also uses `time_sleep`, which requires no external permissions.

## Authentication

This module uses Kubernetes and Vault provider authentication from the caller.

## Features

- Seeds a demo secret in Vault KVv2 (message and image URL).
- Configures VaultConnection and VaultAuth custom resources for VSO.
- Creates a VaultStaticSecret that refreshes from Vault and restarts the deployment.
- Deploys a demo web application, service, and ALB-backed ingress endpoint.

## Usage example

```hcl
module "k8s_demo_app" {
  source = "./modules/k8s-demo-app"

  app_namespace            = "vault-secrets-operator"
  vault_address            = "https://vault.example.com"
  vault_auth_path          = "kubernetes-vso-ca-central-1"
  vault_auth_role          = "vso"
  vault_kv_mount_path      = "kvv2"
  vault_secret_path_prefix = "demo/eks-ca-vso"
}
```

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) (~> 2.25)

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.1)

- <a name="requirement_vault"></a> [vault](#requirement\_vault) (5.8.0)

## Providers

The following providers are used by this module:

- <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) (~> 2.25)

- <a name="provider_time"></a> [time](#provider\_time) (~> 0.1)

- <a name="provider_vault"></a> [vault](#provider\_vault) (5.8.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [kubernetes_deployment.static_app](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) (resource)
- [kubernetes_ingress_v1.static_app](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) (resource)
- [kubernetes_manifest.vault_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) (resource)
- [kubernetes_manifest.vault_connection](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) (resource)
- [kubernetes_manifest.vault_static_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) (resource)
- [kubernetes_service_v1.static_app](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_v1) (resource)
- [time_sleep.wait_60_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [vault_kv_secret_v2.webapp](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_app_namespace"></a> [app\_namespace](#input\_app\_namespace)

Description: (Required) Namespace where the demo application is deployed.

Type: `string`

### <a name="input_demo_app_image"></a> [demo\_app\_image](#input\_demo\_app\_image)

Description: (Required) Container image for the demo web application.

Type: `string`

### <a name="input_vault_address"></a> [vault\_address](#input\_vault\_address)

Description: (Required) Vault address used by the VaultConnection custom resource.

Type: `string`

### <a name="input_vault_auth_path"></a> [vault\_auth\_path](#input\_vault\_auth\_path)

Description: (Required) Vault Kubernetes auth mount path used by VaultAuth.

Type: `string`

### <a name="input_vault_auth_role"></a> [vault\_auth\_role](#input\_vault\_auth\_role)

Description: (Required) Vault role name used by VaultAuth.

Type: `string`

### <a name="input_vault_kv_mount_path"></a> [vault\_kv\_mount\_path](#input\_vault\_kv\_mount\_path)

Description: (Required) Vault KVv2 mount path containing demo secrets.

Type: `string`

### <a name="input_vault_secret_path_prefix"></a> [vault\_secret\_path\_prefix](#input\_vault\_secret\_path\_prefix)

Description: (Required) Vault KVv2 secret prefix used by this demo (cluster-scoped prefix recommended).

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_initial_image_url"></a> [initial\_image\_url](#input\_initial\_image\_url)

Description: (Optional) Initial image URL stored in Vault and rendered by the demo webpage.

Type: `string`

Default: `"https://developer.hashicorp.com/favicon.ico"`

### <a name="input_initial_message"></a> [initial\_message](#input\_initial\_message)

Description: (Optional) Initial message stored in Vault and rendered by the demo webpage.

Type: `string`

Default: `"Secret synced from Vault through VSO."`

### <a name="input_vso_service_account_name"></a> [vso\_service\_account\_name](#input\_vso\_service\_account\_name)

Description: (Optional) Service account used by VaultAuth in the demo namespace.

Type: `string`

Default: `"vault-secrets-operator-controller-manager"`

## Outputs

The following outputs are exported:

### <a name="output_vault_secret_path"></a> [vault\_secret\_path](#output\_vault\_secret\_path)

Description: Vault KVv2 secret path backing the webpage content.

### <a name="output_website_url"></a> [website\_url](#output\_website\_url)

Description: Demo webpage URL exposed through the Kubernetes ingress load balancer.
