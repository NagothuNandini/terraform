variable "eks_endpoint" {
  type        = string
  description = "EKS cluster endpoint URL"
}

variable "cluster_ca_certificate" {
  type        = string
  description = "Base64 encoded cluster CA certificate"
}

variable "cluster_token" {
  type        = string
  description = "Authentication token for the EKS cluster"
  sensitive   = true
}
