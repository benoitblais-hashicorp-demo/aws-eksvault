<!-- markdownlint-disable MD024 -->
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

- terraform (~> 1.14)

- helm (~> 2.12)

- kubernetes (~> 2.25)

- time (~> 0.1)

- vault (~> 5.8)

## Providers

The following providers are used by this module:

- helm (~> 2.12)

- kubernetes (~> 2.25)

- time (~> 0.1)

- vault (~> 5.8)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [helm_release.vso_custom_resources](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [kubernetes_deployment.static_app](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) (resource)
- [kubernetes_ingress_v1.static_app](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) (resource)
- [kubernetes_service_v1.static_app](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_v1) (resource)
- [time_sleep.wait_60_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [time_sleep.wait_for_vso_crd_registration](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [vault_kv_secret_v2.webapp](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) (resource)

## Required Inputs

The following input variables are required:

### app_namespace

Description: (Required) Namespace where the demo application is deployed.

Type: `string`

### demo_app_image

Description: (Required) Container image for the demo web application.

Type: `string`

### vault_address

Description: (Required) Vault address used by the VaultConnection custom resource.

Type: `string`

### vault_auth_path

Description: (Required) Vault Kubernetes auth mount path used by VaultAuth.

Type: `string`

### vault_auth_role

Description: (Required) Vault role name used by VaultAuth.

Type: `string`

### vault_kv_mount_path

Description: (Required) Vault KVv2 mount path containing demo secrets.

Type: `string`

### vault_secret_path_prefix

Description: (Required) Vault KVv2 secret prefix used by this demo (cluster-scoped prefix recommended).

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### initial_image_url

Description: (Optional) Initial image URL stored in Vault and rendered by the demo webpage.

Type: `string`

Default: `"https://developer.hashicorp.com/favicon.ico"`

### initial_message

Description: (Optional) Initial message stored in Vault and rendered by the demo webpage.

Type: `string`

Default: `"Secret synced from Vault through VSO."`

### integration_dependency_token

Description: (Optional) Opaque dependency token from the VSO integration bootstrap release used to enforce ordering.

Type: `string`

Default: `""`

### vso_service_account_name

Description: (Optional) Service account used by VaultAuth in the demo namespace.

Type: `string`

Default: `"vault-secrets-operator-controller-manager"`

## Outputs

The following outputs are exported:

### vault_secret_path

Description: Vault KVv2 secret path backing the webpage content.

### website_url

Description: Demo webpage URL exposed through the Kubernetes ingress load balancer.
