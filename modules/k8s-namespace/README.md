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

- terraform (~> 1.14)

- kubernetes (~> 2.25)

## Resources

The following resources are used by this module:

- [kubernetes_namespace_v1.target](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) (resource)

## Required Inputs

The following input variables are required:

### namespace

Description: (Required) Namespace name to create.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### labels

Description: (Optional) Labels applied to the namespace metadata.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### namespace

Description: Name of the created Kubernetes namespace.
