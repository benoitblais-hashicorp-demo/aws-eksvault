# Vault Integration Bootstrap Terraform module

This module bootstraps Kubernetes-side components for Vault integration demonstrations, including VSO and optional CSI driver support.

## Permissions

Required access for caller identities:

- Kubernetes RBAC for namespace/configmap management:
  - API group `""`, resources `namespaces` and `configmaps`.
  - Verbs `create`, `get`, `list`, `watch`, `patch`, `update`, `delete`.
- Kubernetes RBAC for Helm-managed resources (for VSO and optional CSI chart installation):
  - Core resources typically include `serviceaccounts`, `services`, `configmaps`, `secrets`, `pods`.
  - Apps resources typically include `deployments`, `daemonsets`, `replicasets`.
  - RBAC resources typically include `roles`, `rolebindings`, `clusterroles`, `clusterrolebindings`.
  - Admission resources may include webhook configurations depending on chart version.
  - Practical baseline for demo: cluster-admin for the Helm identity.

## Authentications

Authentication to the target cluster is configured in the caller using one of the following methods supported by both providers.

### Kubeconfig file

Use kubeconfig path and optional context selection.

```hcl
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "my-context"
}

provider "helm" {
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = "my-context"
  }
}
```

Environment variable equivalents:

- `KUBE_CONFIG_PATH` or `KUBE_CONFIG_PATHS`
- `KUBE_CTX`, `KUBE_CTX_AUTH_INFO`, `KUBE_CTX_CLUSTER`

### Explicit host and credentials

Use API endpoint, CA certificate, and token or client certificate/key.

```hcl
provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_cert)
  token                  = var.kubernetes_token
}

provider "helm" {
  kubernetes = {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_cert)
    token                  = var.kubernetes_token
  }
}
```

Environment variable equivalents:

- `KUBE_HOST`, `KUBE_TOKEN`, `KUBE_CLUSTER_CA_CERT_DATA`
- `KUBE_CLIENT_CERT_DATA`, `KUBE_CLIENT_KEY_DATA`

### Exec-based short-lived credentials (recommended for EKS)

Use an exec plugin to fetch fresh tokens (for example with AWS CLI `eks get-token`).

```hcl
provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
  }
}

provider "helm" {
  kubernetes = {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_cert)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    }
  }
}
```

### In-cluster authentication

When Terraform runs inside a pod, both providers can detect in-cluster configuration via `KUBERNETES_SERVICE_HOST` and `KUBERNETES_SERVICE_PORT`.

Provider documentation:

- Kubernetes provider: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
- Helm provider: https://registry.terraform.io/providers/hashicorp/helm/latest/docs

## Features

- Creates a dedicated integration namespace.
- Stores Vault address connection metadata in a config map.
- Installs Vault Secrets Operator.
- Optionally installs Secrets Store CSI Driver for the VSO+CSI mode.

## Usage example

```hcl
module "vault_integration_bootstrap" {
  source = "./modules/vault-integration-bootstrap"

  cluster_name     = "eks-ca-vso"
  integration_mode = "vso"
  namespace        = "vault-secrets-operator"
  vault_address    = "https://vault.example.com"
}
```

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_helm"></a> [helm](#requirement\_helm) (~> 2.13)

- <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) (~> 2.25)

## Providers

The following providers are used by this module:

- <a name="provider_helm"></a> [helm](#provider\_helm) (~> 2.13)

- <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) (~> 2.25)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [helm_release.secrets_store_csi_driver](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [helm_release.vault_secrets_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [kubernetes_config_map_v1.vault_connection](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) (resource)
- [kubernetes_namespace_v1.vault_integration](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name)

Description: (Required) Cluster name used for tagging and release naming.

Type: `string`

### <a name="input_integration_mode"></a> [integration\_mode](#input\_integration\_mode)

Description: (Required) Integration profile.

Type: `string`

### <a name="input_namespace"></a> [namespace](#input\_namespace)

Description: (Required) Namespace where the integration components are installed.

Type: `string`

### <a name="input_vault_address"></a> [vault\_address](#input\_vault\_address)

Description: (Required) Vault address used by downstream configuration.

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_integration_mode"></a> [integration\_mode](#output\_integration\_mode)

Description: Integration mode deployed in this cluster.

### <a name="output_namespace"></a> [namespace](#output\_namespace)

Description: Namespace where Vault integration components are deployed.

### <a name="output_vault_address"></a> [vault\_address](#output\_vault\_address)

Description: Vault address configured for the integration bootstrap.
