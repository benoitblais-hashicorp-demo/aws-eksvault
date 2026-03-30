# Kubernetes Namespace Terraform module

This module creates a Kubernetes namespace and applies metadata labels.

## Permissions

Required Kubernetes RBAC for the caller identity:

- API group: `""`.
- Resource: `namespaces`.
- Verbs: `create`, `get`, `list`, `watch`, `patch`, `update`, `delete`.

Example role scope: cluster-scoped permission via `ClusterRole` and `ClusterRoleBinding`.

## Authentication

This module uses Kubernetes provider authentication from the caller.

## Features

- Creates a namespace.
- Applies customizable labels.

## Usage example

```hcl
module "k8s_namespace" {
  source = "./modules/k8s-namespace"

  namespace = "vault-secrets-operator"
}
```

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) (~> 2.25)

## Providers

The following providers are used by this module:

- <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) (~> 2.25)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [kubernetes_namespace_v1.example](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_namespace"></a> [namespace](#input\_namespace)

Description: (Required) Namespace name to create.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_labels"></a> [labels](#input\_labels)

Description: (Optional) Labels applied to the namespace metadata.

Type: `any`

Default:

```json
{
  "mylabel": "example-label"
}
```

## Outputs

The following outputs are exported:

### <a name="output_namespace"></a> [namespace](#output\_namespace)

Description: Name of the created Kubernetes namespace.
