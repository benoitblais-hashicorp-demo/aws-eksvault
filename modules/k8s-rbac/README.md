# Kubernetes RBAC Terraform module

This module creates a cluster role binding for OIDC-based access mapping used by Terraform Cloud organization identities.

## Permissions

Required Kubernetes RBAC for the caller identity:

- API group: `rbac.authorization.k8s.io`.
- Resource: `clusterrolebindings`.
- Verbs: `create`, `get`, `list`, `watch`, `patch`, `update`, `delete`.
- Read access to referenced cluster roles: `clusterroles` with `get`.

The module also uses the `time` provider, which requires no external permissions.

## Authentication

This module uses Kubernetes provider authentication from the caller.

## Features

- Waits for cluster readiness before applying RBAC.
- Creates an organization group to cluster-admin role binding.

## Usage example

```hcl
module "k8s_rbac" {
  source = "./modules/k8s-rbac"

  cluster_endpoint      = "https://example.eks.amazonaws.com"
  tfc_organization_name = "example-org"
}
```

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) (~> 2.25)

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.1)

## Providers

The following providers are used by this module:

- <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) (~> 2.25)

- <a name="provider_time"></a> [time](#provider\_time) (~> 0.1)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [kubernetes_cluster_role_binding_v1.oidc_role](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding_v1) (resource)
- [time_sleep.wait_for_cluster](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint)

Description: (Required) Kubernetes API server endpoint URL.

Type: `string`

### <a name="input_tfc_organization_name"></a> [tfc\_organization\_name](#input\_tfc\_organization\_name)

Description: (Required) Terraform Cloud organization name used for RBAC mapping.

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_oidc_binding_id"></a> [oidc\_binding\_id](#output\_oidc\_binding\_id)

Description: Identifier of the Kubernetes OIDC cluster role binding.
