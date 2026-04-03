# AWS VPC Terraform module

This module provisions a VPC foundation for EKS workloads, including public and private subnets and routing prerequisites.

## Permissions

Required AWS IAM access for the caller identity:

- AWS managed policy baseline: `AmazonVPCFullAccess`.
- If you do not use the managed policy, allow at minimum these actions:
  - `ec2:CreateVpc`, `ec2:DeleteVpc`, `ec2:DescribeVpcs`.
  - `ec2:CreateSubnet`, `ec2:DeleteSubnet`, `ec2:DescribeSubnets`.
  - `ec2:CreateRouteTable`, `ec2:DeleteRouteTable`, `ec2:CreateRoute`, `ec2:ReplaceRouteTableAssociation`, `ec2:AssociateRouteTable`, `ec2:DisassociateRouteTable`.
  - `ec2:CreateInternetGateway`, `ec2:AttachInternetGateway`, `ec2:DetachInternetGateway`, `ec2:DeleteInternetGateway`.
  - `ec2:CreateNatGateway`, `ec2:DeleteNatGateway`, `ec2:DescribeNatGateways`.
  - `ec2:AllocateAddress`, `ec2:ReleaseAddress`, `ec2:DescribeAddresses`.
  - `ec2:CreateTags`, `ec2:DeleteTags`.

## Authentication

This module uses the AWS provider authentication configured by the caller.

## Features

- Creates a VPC with configurable CIDR.
- Creates private and public subnets across availability zones.
- Enables a single NAT gateway for cost-optimized outbound connectivity.
- Applies tags for consistent resource identification.

## Usage example

```hcl
module "vpc" {
  source = "./modules/aws-vpc"

  vpc_name = "vpc-ca"
  vpc_cidr = "10.0.0.0/16"
}
```

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (~> 5.0)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (~> 5.0)

## Modules

The following Modules are called:

### <a name="module_vpc"></a> [vpc](#module\_vpc)

Source: terraform-aws-modules/vpc/aws

Version: ~> 6.0

## Resources

The following resources are used by this module:

- [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr)

Description: (Required) CIDR block for the VPC.

Type: `string`

### <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name)

Description: (Required) Name of the VPC.

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets)

Description: List of private subnet identifiers created in the VPC.

### <a name="output_route_table_id"></a> [route\_table\_id](#output\_route\_table\_id)

Description: List of private route table identifiers created in the VPC.

### <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id)

Description: Identifier of the VPC.
