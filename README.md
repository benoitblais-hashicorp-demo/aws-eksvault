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
