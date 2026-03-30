resource "vault_mount" "kvv2" {
  path = var.mount_path
  type = "kv-v2"
}
