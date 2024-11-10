variable "cluster_name" {
    type = string
}

variable "cluster_version" {
    type = string
}

variable "private_subnets" {
  type = map
}

variable "security_group_eks" {
  type = map
}