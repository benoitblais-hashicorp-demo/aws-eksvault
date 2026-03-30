variable "app_namespace" {
  description = "(Required) Namespace where the demo application is deployed."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.app_namespace))
    error_message = "The `app_namespace` variable must be a valid Kubernetes namespace name."
  }
}
