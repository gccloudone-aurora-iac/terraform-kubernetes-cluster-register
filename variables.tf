variable "namespace" {
  description = "The namespace the service account will exist in."
  type        = string
}

variable "service_account_name" {
  description = "The name of the Kubernetes service account created."
  type        = string
}

variable "role_binding" {
  description = "Details about the Kubernetes role binding to create with the service account subject."
  type = object({
    scope     = string
    role_name = string
  })

  validation {
    condition     = var.role_binding.scope == "cluster" || var.role_binding.scope == "namespace"
    error_message = "var.role_binding.scope must be set to either 'cluser' or 'namespace'."
  }
}
