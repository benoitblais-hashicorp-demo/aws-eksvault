# AGENTS.md for Terraform Stacks

This file provides instructions for AI coding agents working on this Terraform Stacks.

## Project Overview

This project manages AWS ressources using Terraform Stacks.

## Module and Repository Structure

Organize your Terraform Stacks project as follows:

```text
├── .gitignore
├── LICENSE
├── README.md
├── components.tfcomponent.hcl
├── deployments.tfdeploy.hcl
├── providers.tfcomponent.hcl
├── variables.tfcomponent.hcl
├── modules/
│   ├── {module_name}/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── README.md
│   │   ├── variables.tf
│   │   ├── versions.tf
├── docs/
│   ├── CODE_OF_CONDUCT.md
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── SECURITY.md
```

### Required Files and Directories

**For Stack Configuration (Root):**

- `README.md` – High-level documentation explaining the stack's purpose, architecture, and deployment environments.
- `components.tfcomponent.hcl` – Defines the logical components of the stack.
- `deployments.tfdeploy.hcl` / `deployment_*.tfdeploy.hcl` – Defines environments and deployment targets.
- `providers.tfcomponent.hcl` – Shared provider configurations for all components.
- `variables.tfcomponent.hcl` – Input variables for the entire stack.

**For Child Modules (`modules/*/`):**

- `README.md` – Module-specific documentation explaining usage, inputs, and resources.
- `main.tf` – Primary resource and data source definitions. Must exist in every module, even if empty.
- `outputs.tf` – Output value definitions (alphabetical order). Must exist in every module, even if empty.
- `variables.tf` – Input variable definitions (alphabetical order with required at the top). Must exist in every module, even if empty.
- `versions.tf` - Terraform version and provider requirements.

## Tools and Frameworks

- Always run `terraform fmt -recursive` after generating code to enforce formatting.

## Code Guidelines

Refer to CONTRIBUTING.md for general coding guidelines.

## Resource Naming

- Use descriptive nouns separated by underscores
- Do not include the resource type in the resource name
- Wrap resource type and name in double quotes
- Example: `resource "aws_instance" "web_server" {}` not `resource "aws_instance" "webserver_instance" {}`

## Version Management

- Prefer the pessimistic constraint operator (`~>`) for modules and providers to allow safe updates within a compatible version range.
- Avoid using only the equals (`=`) operator unless you must lock to a single version for reproducibility or known issues.
- Pin Terraform version using `required_version` in terraform block.
- Example: `version = "~> 5.34"` not `version = "5.34.0"`

## Provider Configuration

- Always include a default provider configuration
- Define all providers in the same file (`providers.tfcomponent.hcl` for the root stack, or `providers.tf` for child modules)
- Define the default provider first, then aliased providers
- Use `alias` as the first parameter in non-default provider blocks

## Security and Secrets

- Never commit `.terraform` directories or local state files if used for testing.
- Use dynamic provider credentials configured at the HCP Terraform Stack/Deployment level.
- Access secrets from external secret management systems or securely via Stack variables.
- Set `sensitive = true` for sensitive variables across all component definitions.

## State Management

- State storage is managed natively by HCP Terraform for Stacks.
- Pass outputs natively between stack components within `components.tfcomponent.hcl` rather than using `tfe_outputs` or `terraform_remote_state` data sources.
- Separate environments (e.g., dev, prod) by using deployment configurations (`.tfdeploy.hcl`) instead of separate directories or traditional workspaces.
