# Contributing to AWS-EKSVault Stacks Demo

Thank you for your interest in contributing! This repository uses **HashiCorp HCP Terraform Stacks** to manage AWS, EKS, and Vault infrastructure. Because Stacks handle environments and dependencies differently than traditional Terraform modules, please review these guidelines before contributing.

## Architecture Paradigm: Terraform Stacks

Unlike standard Terraform configuration where you might use `terraform init/plan/apply` locally against a `main.tf` file, this project leverages Stacks (`.tfcomponent.hcl` and `.tfdeploy.hcl`).

* **No Local State or CLI Applies:** Do not run `terraform apply` locally. All pushes to the main branch are evaluated and deployed by HCP Terraform natively.
* **No `tfe_outputs`:** Data is passed natively between components using Stack references (e.g., `component.vpc.network_id`).
* **No `for_each` for Regions:** Do not use `for_each` inside components to manage multi-region redundancy. If multi-region is needed, define multiple `deployment` blocks inside `.tfdeploy.hcl`.

## Development Workflow

1. **Fork & Branch:** Create a branch for your feature or bug fix.
2. **Write Code:** Modify the component architectures or add new standard modules under `modules/`.
3. **Format:** You MUST run `terraform fmt -recursive` before committing. Unformatted code will fail CI/CD checks.
4. **Open a Pull Request:** Fill out the provided PR template outlining your changes.

## Code Guidelines

* **Minimalism:** This is a demonstration repository. Favor readability and simplicity over highly complex abstractions.
* **Variable Descriptions:** Every variable must have a clear `description` and `type`.
* **Version Constraints:** Use the pessimistic operator (`~>`) for provider and module versions to ensure stability without strict lock-in.
* **Naming Conventions:** Use `snake_case` for all resource, component, and variable names. Avoid including the resource type in the name (i.e., `aws_vpc.main`, not `aws_vpc.vpc_main`).

## Security Check

* Never commit `.terraform` folders, `.tfstate` files, or `.tfvars` files containing actual secrets.
* All provider credentials must remain dynamic via OIDC/Identity Tokens mapped at the deployment level.

If you find a security vulnerability, please refer to our `SECURITY.md` for reporting procedures.
