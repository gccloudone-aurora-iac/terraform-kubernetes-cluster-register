#################
### Providers ###
#################

provider "kubernetes" {
}

##############################
### Service Account Module ###
##############################

resource "kubernetes_namespace" "platform_system" {
  metadata {
    name = "platform-system"
  }
}

module "example_service_account" {
  source = "../"

  service_account_name = "argocd-mgmt"
  namespace            = "platform-system"

  role_binding = {
    scope     = "cluster"
    role_name = "cluster-admin"
  }
}
