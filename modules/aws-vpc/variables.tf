variable "vpc_cidr" {
  description = "(Required) CIDR block for the VPC."
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "The `vpc_cidr` variable must be a valid CIDR block."
  }
}

variable "vpc_name" {
  description = "(Required) Name of the VPC."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9-]+$", var.vpc_name))
    error_message = "The `vpc_name` variable must start with \"vpc-\" and contain only lowercase letters, numbers, and hyphens."
  }
}
