module "vpc" {
  source = "./modules/vpc"

  cluster_name = var.cluster_name
}

module "eks" {
  source = "./modules/eks"

  private_subnets    = module.vpc.private_subnets
  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  security_group_eks = module.vpc.security_group_eks
}