resource "aws_eks_addon" "vpc-cni" {
  cluster_name    = aws_eks_cluster.cluster.name
  addon_name      = "vpc-cni"
  addon_version   = "v1.18.5-eksbuild.1"
}
################################################################################################################
locals {
  core_dns_config = file("${path.module}/configs/core-dns.json")
}

resource "aws_eks_addon" "CoreDNS" {
  cluster_name    = aws_eks_cluster.cluster.name
  addon_name      = "coredns"
  addon_version   = "v1.11.3-eksbuild.2"

  configuration_values = local.core_dns_config
}

################################################################################################################
resource "aws_eks_addon" "PodIdentity" {
  cluster_name    = aws_eks_cluster.cluster.name
  addon_name      = "eks-pod-identity-agent"
  addon_version   = "v1.0.0-eksbuild.1"
}