# AWS Bastion EC2 Instance Type and key pair
variable "instance_type" {
  description = "bastion Instance Type"
  type        = string
  default     = ""
}

variable "instance_keypair" {
  description = "AWS EC2 Key pair that need to be associated with bastion Instance"
  type        = string
  default     = "aws-terraform-key"
}

variable "eks_nodes_keypair" {
  description = "RSA private key used to open an SSH connection from the bastion host"
  type        = string
  default     = "eks_nodes_keypair"
}

variable "cluster_name" {
  default = "ekscluster-simpleecommerce"
  type = string
  description = "AWS EKS CLuster Name"
  nullable = false
}