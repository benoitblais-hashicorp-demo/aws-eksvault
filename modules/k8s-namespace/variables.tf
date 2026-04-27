variable "namespace" {
  description = "(Required) Namespace name to create."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.namespace))
    error_message = "The `namespace` variable must be a valid Kubernetes namespace name."
  }
}

variable "labels" {
  description = "(Optional) Labels applied to the namespace metadata."
  type        = map(string)
  default     = {}
}
