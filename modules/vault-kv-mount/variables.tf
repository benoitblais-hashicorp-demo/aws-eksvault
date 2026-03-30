variable "mount_path" {
  description = "(Required) Vault KVv2 mount path to create once for demo secret storage."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-_/]*$", var.mount_path))
    error_message = "The `mount_path` variable must contain only lowercase letters, numbers, dash, underscore, and slash."
  }
}
