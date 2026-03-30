# Kubernetes Demo App Terraform module

This module deploys a demo web application to Kubernetes with service and ingress resources.

## Permissions

Required Kubernetes RBAC for the caller identity in the target namespace:

- API group `apps`, resource `deployments`, verbs `create`, `get`, `list`, `watch`, `patch`, `update`, `delete`.
- API group `""`, resources `services` and `pods`, verbs `create`, `get`, `list`, `watch`, `patch`, `update`, `delete`.
- API group `networking.k8s.io`, resource `ingresses`, verbs `create`, `get`, `list`, `watch`, `patch`, `update`, `delete`.

The module also uses `time_sleep`, which requires no external permissions.

## Authentication

This module uses Kubernetes provider authentication from the caller.

## Features

- Deploys a single-replica demo application.
- Creates a ClusterIP service.
- Creates an ingress resource for external routing.

## Usage example

```hcl
module "k8s_demo_app" {
  source = "./modules/k8s-demo-app"

  app_namespace = "demo-app"
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

- [kubernetes_deployment.hashibank](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) (resource)
- [kubernetes_ingress_v1.hashibank](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) (resource)
- [kubernetes_service_v1.hashibank](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_v1) (resource)
- [time_sleep.wait_60_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_app_namespace"></a> [app\_namespace](#input\_app\_namespace)

Description: (Required) Namespace where the demo application is deployed.

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

No outputs.
