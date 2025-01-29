output "service_account" {
  value = kubernetes_service_account.this
}

output "service_account_token_secret" {
  value = kubernetes_secret.this
}

output "cluster_role_binding" {
  value = kubernetes_cluster_role_binding.this
}

output "role_binding" {
  value = kubernetes_role_binding.this
}
