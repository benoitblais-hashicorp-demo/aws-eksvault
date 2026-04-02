# AWS-EKSVault

<!-- Trigger commit: no functional changes -->

Terraform Stacks code to provision AWS infrastructure for two EKS-based Vault integration demos:

- A VSO-focused EKS cluster
- A VSO with CSI-focused EKS cluster
# aws-eksvault

Terraform Stacks code to provision AWS infrastructure for two EKS-based Vault integration demos:

- A VSO-focused EKS cluster
- A VSO with CSI-focused EKS cluster

## Current Scope (AWS-first iteration)

This iteration provisions and bootstraps the AWS/EKS side:

- VPC with private subnets and NAT gateway for outbound internet access
- Two EKS Fargate clusters in the same VPC
- Baseline EKS add-ons and namespace setup per cluster
- Optional cluster-side bootstrap for Vault integrations

Vault-side authentication and policy configuration is intentionally deferred to the next iteration.

## Toggle Vault bootstrap

In `deployments.tfdeploy.hcl`, set:

- `vault_address` to your HCP Vault URL to enable bootstrap
- `install_vso = true` to bootstrap VSO lane
- `install_vso_csi = true` to bootstrap VSO+CSI lane

If `vault_address` is empty, Vault bootstrap components are skipped.


<!-- BEGIN_TF_DOCS -->
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

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.6.0)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (~> 5.0)

- <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) (~> 2.0)

- <a name="requirement_helm"></a> [helm](#requirement\_helm) (~> 2.12)

- <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) (~> 2.25)

- <a name="requirement_local"></a> [local](#requirement\_local) (~> 2.4)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.7.0)

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.1)

- <a name="requirement_tls"></a> [tls](#requirement\_tls) (~> 4.0)

- <a name="requirement_vault"></a> [vault](#requirement\_vault) (5.8.0)

## Modules

The following Modules are called:

### <a name="module_eks_vso"></a> [eks\_vso](#module\_eks\_vso)

Source: terraform-aws-modules/eks/aws

Version: 20.2.0

### <a name="module_eks_vso_csi"></a> [eks\_vso\_csi](#module\_eks\_vso\_csi)

Source: terraform-aws-modules/eks/aws

Version: 20.2.0

### <a name="module_k8s_addons_vso"></a> [k8s\_addons\_vso](#module\_k8s\_addons\_vso)

Source: ./modules/aws-eks-addon

Version:

### <a name="module_k8s_addons_vso_csi"></a> [k8s\_addons\_vso\_csi](#module\_k8s\_addons\_vso\_csi)

Source: ./modules/aws-eks-addon

Version:

### <a name="module_k8s_demo_app_vso"></a> [k8s\_demo\_app\_vso](#module\_k8s\_demo\_app\_vso)

Source: ./modules/k8s-demo-app

Version:

### <a name="module_k8s_demo_app_vso_csi"></a> [k8s\_demo\_app\_vso\_csi](#module\_k8s\_demo\_app\_vso\_csi)

Source: ./modules/k8s-demo-app

Version:

### <a name="module_k8s_edr_vso"></a> [k8s\_edr\_vso](#module\_k8s\_edr\_vso)

Source: ./modules/k8s-edr-uptycs

Version:

### <a name="module_k8s_edr_vso_csi"></a> [k8s\_edr\_vso\_csi](#module\_k8s\_edr\_vso\_csi)

Source: ./modules/k8s-edr-uptycs

Version:

### <a name="module_k8s_namespace_vso"></a> [k8s\_namespace\_vso](#module\_k8s\_namespace\_vso)

Source: ./modules/k8s-namespace

Version:

### <a name="module_k8s_namespace_vso_csi"></a> [k8s\_namespace\_vso\_csi](#module\_k8s\_namespace\_vso\_csi)

Source: ./modules/k8s-namespace

Version:

### <a name="module_k8s_rbac_vso"></a> [k8s\_rbac\_vso](#module\_k8s\_rbac\_vso)

Source: ./modules/k8s-rbac

Version:

### <a name="module_k8s_rbac_vso_csi"></a> [k8s\_rbac\_vso\_csi](#module\_k8s\_rbac\_vso\_csi)

Source: ./modules/k8s-rbac

Version:

### <a name="module_vault_config_vso"></a> [vault\_config\_vso](#module\_vault\_config\_vso)

Source: ./modules/vault-kubernetes-auth

Version:

### <a name="module_vault_config_vso_csi"></a> [vault\_config\_vso\_csi](#module\_vault\_config\_vso\_csi)

Source: ./modules/vault-kubernetes-auth

Version:

### <a name="module_vault_integration_vso"></a> [vault\_integration\_vso](#module\_vault\_integration\_vso)

Source: ./modules/vault-integration-bootstrap

Version:

### <a name="module_vault_integration_vso_csi"></a> [vault\_integration\_vso\_csi](#module\_vault\_integration\_vso\_csi)

Source: ./modules/vault-integration-bootstrap

Version:

### <a name="module_vault_kv_mount"></a> [vault\_kv\_mount](#module\_vault\_kv\_mount)

Source: ./modules/vault-kv-mount

Version:

### <a name="module_vpc"></a> [vpc](#module\_vpc)

Source: terraform-aws-modules/vpc/aws

Version: 6.6.0

## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_az_filter_instance_type"></a> [az\_filter\_instance\_type](#input\_az\_filter\_instance\_type)

Description: (Optional) EC2 instance type used to filter supported availability zones.

Type: `string`

Default: `"m5.large"`

### <a name="input_cluster_name_vso"></a> [cluster\_name\_vso](#input\_cluster\_name\_vso)

Description: (Optional) Name of the EKS cluster dedicated to VSO demonstrations.

Type: `string`

Default: `"eks-ca-vso"`

### <a name="input_cluster_name_vso_csi"></a> [cluster\_name\_vso\_csi](#input\_cluster\_name\_vso\_csi)

Description: (Optional) Name of the EKS cluster dedicated to VSO with CSI demonstrations.

Type: `string`

Default: `"eks-ca-csi"`

### <a name="input_clusteradmin_role_name"></a> [clusteradmin\_role\_name](#input\_clusteradmin\_role\_name)

Description: (Optional) Name for the IAM role to create for cluster admin access.

Type: `string`

Default: `""`

### <a name="input_csi_service_account_name"></a> [csi\_service\_account\_name](#input\_csi\_service\_account\_name)

Description: (Optional) Service account name bound to the Vault role for CSI integration.

Type: `string`

Default: `"vault-csi-provider"`

### <a name="input_csi_service_account_namespace"></a> [csi\_service\_account\_namespace](#input\_csi\_service\_account\_namespace)

Description: (Optional) Namespace for the CSI provider service account bound to Vault auth.

Type: `string`

Default: `"kube-system"`

### <a name="input_demo_webapp_image"></a> [demo\_webapp\_image](#input\_demo\_webapp\_image)

Description: (Optional) Demo webapp image. Leave empty to skip demo deployment.

Type: `string`

Default: `"ghcr.io/benoitblais-hashicorp-demo/demo-go-web:v1.1.0"`

### <a name="input_edr_helm_chart"></a> [edr\_helm\_chart](#input\_edr\_helm\_chart)

Description: (Optional) Uptycs EDR Helm chart name.

Type: `string`

Default: `"k8sosquery"`

### <a name="input_edr_helm_chart_version"></a> [edr\_helm\_chart\_version](#input\_edr\_helm\_chart\_version)

Description: (Optional) Uptycs EDR Helm chart version.

Type: `string`

Default: `""`

### <a name="input_edr_helm_repository"></a> [edr\_helm\_repository](#input\_edr\_helm\_repository)

Description: (Optional) Uptycs EDR Helm repository URL.

Type: `string`

Default: `"https://uptycslabs.github.io/kspm-helm-charts"`

### <a name="input_edr_k8sosquery_values_yaml"></a> [edr\_k8sosquery\_values\_yaml](#input\_edr\_k8sosquery\_values\_yaml)

Description: (Optional) Raw YAML values for Uptycs EDR chart.

Type: `string`

Default: `""`

### <a name="input_edr_namespace"></a> [edr\_namespace](#input\_edr\_namespace)

Description: (Optional) Namespace where Uptycs EDR components are deployed.

Type: `string`

Default: `"uptycs"`

### <a name="input_edr_uptycs_tags"></a> [edr\_uptycs\_tags](#input\_edr\_uptycs\_tags)

Description: (Optional) Uptycs tags for Kubernetes EDR in UPDATE/CCODE/UT/OWNER format.

Type: `string`

Default: `"UPDATE/PROD,CCODE/HashiCorp,UT/20A7V,OWNER/security-team@ibm.com"`

### <a name="input_enable_vso_cluster"></a> [enable\_vso\_cluster](#input\_enable\_vso\_cluster)

Description: (Optional) Whether to deploy the VSO EKS cluster and its dependent components.

Type: `bool`

Default: `true`

### <a name="input_enable_vso_csi_cluster"></a> [enable\_vso\_csi\_cluster](#input\_enable\_vso\_csi\_cluster)

Description: (Optional) Whether to deploy the VSO+CSI EKS cluster and its dependent components.

Type: `bool`

Default: `true`

### <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version)

Description: (Optional) Kubernetes version to use for the EKS clusters.

Type: `string`

Default: `"1.35"`

### <a name="input_namespace_vso"></a> [namespace\_vso](#input\_namespace\_vso)

Description: (Optional) Namespace used in the VSO demo cluster.

Type: `string`

Default: `"vault-secrets-operator"`

### <a name="input_namespace_vso_csi"></a> [namespace\_vso\_csi](#input\_namespace\_vso\_csi)

Description: (Optional) Namespace used in the VSO+CSI demo cluster.

Type: `string`

Default: `"vault-secrets-csi"`

### <a name="input_region"></a> [region](#input\_region)

Description: (Optional) AWS region where resources are deployed.

Type: `string`

Default: `"ca-central-1"`

### <a name="input_tfc_hostname"></a> [tfc\_hostname](#input\_tfc\_hostname)

Description: (Optional) Terraform Cloud or Terraform Enterprise hostname.

Type: `string`

Default: `"https://app.terraform.io"`

### <a name="input_tfc_kubernetes_audience"></a> [tfc\_kubernetes\_audience](#input\_tfc\_kubernetes\_audience)

Description: (Optional) Audience value used by OIDC RBAC mapping.

Type: `string`

Default: `"k8s.workload.identity"`

### <a name="input_tfc_organization_name"></a> [tfc\_organization\_name](#input\_tfc\_organization\_name)

Description: (Optional) Name of the Terraform Cloud organization used by RBAC.

Type: `string`

Default: `"benoitblais-hashicorp"`

### <a name="input_vault_address"></a> [vault\_address](#input\_vault\_address)

Description: (Optional) Vault address. Leave empty to skip Vault components.

Type: `string`

Default: `""`

### <a name="input_vault_kubernetes_auth_path_vso"></a> [vault\_kubernetes\_auth\_path\_vso](#input\_vault\_kubernetes\_auth\_path\_vso)

Description: (Optional) Base Vault Kubernetes auth mount path used for the VSO cluster.

Type: `string`

Default: `"kubernetes-vso"`

### <a name="input_vault_kubernetes_auth_path_vso_csi"></a> [vault\_kubernetes\_auth\_path\_vso\_csi](#input\_vault\_kubernetes\_auth\_path\_vso\_csi)

Description: (Optional) Base Vault Kubernetes auth mount path used for the VSO+CSI cluster.

Type: `string`

Default: `"kubernetes-vso-csi"`

### <a name="input_vault_kubernetes_token_reviewer_jwt"></a> [vault\_kubernetes\_token\_reviewer\_jwt](#input\_vault\_kubernetes\_token\_reviewer\_jwt)

Description: (Optional) Token reviewer JWT used by Vault Kubernetes auth backends.

Type: `string`

Default: `""`

### <a name="input_vault_kv_mount_path"></a> [vault\_kv\_mount\_path](#input\_vault\_kv\_mount\_path)

Description: (Optional) KVv2 mount path used for demo secrets.

Type: `string`

Default: `"kvv2"`

### <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace)

Description: (Optional) Vault namespace where resources are managed.

Type: `string`

Default: `"admin"`

### <a name="input_vault_secret_path_prefix"></a> [vault\_secret\_path\_prefix](#input\_vault\_secret\_path\_prefix)

Description: (Optional) Secret path prefix under the KVv2 mount for demo reads.

Type: `string`

Default: `"demo"`

### <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr)

Description: (Optional) CIDR block for the VPC network.

Type: `string`

Default: `"10.0.0.0/16"`

### <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name)

Description: (Optional) Name of the VPC to be created.

Type: `string`

Default: `"vpc-ca"`

### <a name="input_vso_service_account_name"></a> [vso\_service\_account\_name](#input\_vso\_service\_account\_name)

Description: (Optional) Service account name bound to the Vault role for VSO.

Type: `string`

Default: `"vault-secrets-operator-controller-manager"`

## Resources

The following resources are used by this module:

- [aws_eks_identity_provider_config.oidc_config_vso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_identity_provider_config) (resource)
- [aws_eks_identity_provider_config.oidc_config_vso_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_identity_provider_config) (resource)
- [aws_iam_role.eks_clusteradmin_vso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_iam_role.eks_clusteradmin_vso_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) (data source)
- [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) (data source)
- [aws_ec2_instance_type_offerings.supported](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_instance_type_offerings) (data source)
- [aws_eks_cluster_auth.vso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) (data source)
- [aws_eks_cluster_auth.vso_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) (data source)

## Outputs

The following outputs are exported:

### <a name="output_cluster_name_vso"></a> [cluster\_name\_vso](#output\_cluster\_name\_vso)

Description: VSO EKS cluster name.

### <a name="output_cluster_name_vso_csi"></a> [cluster\_name\_vso\_csi](#output\_cluster\_name\_vso\_csi)

Description: VSO+CSI EKS cluster name.

### <a name="output_configure_kubectl_vso"></a> [configure\_kubectl\_vso](#output\_configure\_kubectl\_vso)

Description: Command to update kubeconfig for the VSO EKS cluster.

### <a name="output_configure_kubectl_vso_csi"></a> [configure\_kubectl\_vso\_csi](#output\_configure\_kubectl\_vso\_csi)

Description: Command to update kubeconfig for the VSO+CSI EKS cluster.

### <a name="output_container_image_used"></a> [container\_image\_used](#output\_container\_image\_used)

Description: Container image deployed by the demo webapp modules.

### <a name="output_demo_webapp_url_vso"></a> [demo\_webapp\_url\_vso](#output\_demo\_webapp\_url\_vso)

Description: Demo webapp URL in VSO lane.

### <a name="output_demo_webapp_url_vso_csi"></a> [demo\_webapp\_url\_vso\_csi](#output\_demo\_webapp\_url\_vso\_csi)

Description: Demo webapp URL in VSO+CSI lane.

### <a name="output_vault_auth_path_vso"></a> [vault\_auth\_path\_vso](#output\_vault\_auth\_path\_vso)

Description: Vault auth path for VSO cluster.

### <a name="output_vault_auth_path_vso_csi"></a> [vault\_auth\_path\_vso\_csi](#output\_vault\_auth\_path\_vso\_csi)

Description: Vault auth path for VSO+CSI cluster.

### <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id)

Description: VPC identifier.

<!-- markdownlint-enable -->
# External Documentation
<!-- END_TF_DOCS -->