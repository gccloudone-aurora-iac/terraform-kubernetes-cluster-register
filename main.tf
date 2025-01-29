# A service account provides an identity for processes that run in a Pod.
#
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account
#
resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace
  }

  lifecycle {
    ignore_changes = [
      image_pull_secret,
    ]
  }
}

# The resource provides mechanisms to inject containers with sensitive information, such as passwords, while keeping containers agnostic of Kubernetes.
#
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret
#
resource "kubernetes_secret" "this" {
  metadata {
    name      = "${var.service_account_name}-token"
    namespace = var.namespace

    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.this.metadata.0.name
    }
  }

  type = "kubernetes.io/service-account-token"
}

# A ClusterRoleBinding may be used to grant permission at the cluster level and in all namespaces.
#
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding
#
resource "kubernetes_cluster_role_binding" "this" {
  count = var.role_binding.scope == "cluster" ? 1 : 0

  metadata {
    name = var.service_account_name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = var.role_binding.role_name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata.0.name
    namespace = var.namespace
  }
}

# A RoleBinding may be used to grant permission at the namespace level.
#
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding
#
resource "kubernetes_role_binding" "this" {
  count = var.role_binding.scope == "namespace" ? 1 : 0

  metadata {
    name      = var.service_account_name
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = var.role_binding.role_name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata.0.name
    namespace = var.namespace
  }
}
