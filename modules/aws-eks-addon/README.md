# AWS EKS Add-on Terraform module

This module installs and manages core EKS add-ons and AWS Load Balancer Controller for an existing EKS cluster.

## Permissions

Required access for caller identities:

- AWS IAM baseline:
  - `eks:DescribeCluster`, `eks:DescribeAddonVersions`, `eks:CreateAddon`, `eks:UpdateAddon`, `eks:DeleteAddon`.
  - IAM for controller integration: `iam:CreateRole`, `iam:DeleteRole`, `iam:AttachRolePolicy`, `iam:DetachRolePolicy`, `iam:PassRole`, `iam:GetRole`, `iam:TagRole`.
  - Supporting reads: `ec2:Describe*`, `elasticloadbalancing:Describe*`, `acm:ListCertificates`, `acm:DescribeCertificate`.
- Kubernetes RBAC for the Kubernetes provider identity:
  - API groups/resources/verbs at cluster scope sufficient to create service accounts, cluster roles, cluster role bindings, roles, role bindings, services, deployments, daemonsets, configmaps, and validating webhooks.
  - Practical baseline for demo: cluster-admin.
- Helm provider uses the same Kubernetes RBAC scope as above.

## Authentication

This module uses AWS, Kubernetes, and Helm providers passed from the caller.

## Features

- Manages key EKS add-ons such as CoreDNS, VPC CNI, and kube-proxy.
- Installs AWS Load Balancer Controller.
- Supports Fargate-oriented add-on settings.

## Usage example

```hcl
module "eks_addons" {
  source = "./modules/aws-eks-addon"

  cluster_certificate_authority_data = "BASE64_CA"
  cluster_endpoint                   = "https://example.eks.amazonaws.com"
  cluster_name                       = "eks-ca-vso"
  cluster_version                    = "1.30"
  oidc_binding_id                    = "rbac-binding-id"
  oidc_provider_arn                  = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.region.amazonaws.com/id/example"
  vpc_id                             = "vpc-123456"
}
```

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

## Providers

No providers.

## Modules

The following Modules are called:

### <a name="module_eks_blueprints_addons"></a> [eks\_blueprints\_addons](#module\_eks\_blueprints\_addons)

Source: aws-ia/eks-blueprints-addons/aws

Version: 1.1

## Resources

No resources.

## Required Inputs

The following input variables are required:

### <a name="input_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#input\_cluster\_certificate\_authority\_data)

Description: (Required) Base64-encoded cluster certificate authority data.

Type: `string`

### <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint)

Description: (Required) Kubernetes API server endpoint URL.

Type: `string`

### <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name)

Description: (Required) EKS cluster name.

Type: `string`

### <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version)

Description: (Required) Kubernetes version used by the EKS cluster.

Type: `string`

### <a name="input_oidc_binding_id"></a> [oidc\_binding\_id](#input\_oidc\_binding\_id)

Description: (Required) OIDC binding identifier used for component dependency ordering.

Type: `string`

### <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn)

Description: (Required) OIDC provider ARN associated with the EKS cluster.

Type: `string`

### <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id)

Description: (Required) VPC identifier where EKS resources are deployed.

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_argo_workflows"></a> [argo\_workflows](#output\_argo\_workflows)

Description: Map of attributes for the Argo Workflows Helm release.

### <a name="output_aws_load_balancer_controller"></a> [aws\_load\_balancer\_controller](#output\_aws\_load\_balancer\_controller)

Description: Map of attributes for the AWS Load Balancer Controller Helm release and IRSA resources.

### <a name="output_eks_addons"></a> [eks\_addons](#output\_eks\_addons)

Description: Map of attributes for enabled EKS add-ons.
