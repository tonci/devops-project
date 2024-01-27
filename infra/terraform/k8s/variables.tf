variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_version" {
  description  = "AWS EKS cluster version"
  type         = string
  default      = "1.28"
}