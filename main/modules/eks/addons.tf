resource "aws_eks_addon" "vpc-cni" {
  cluster_name    = aws_eks_cluster.cluster.name
  addon_name      = "vpc-cni"
  addon_version   = "v1.18.5-eksbuild.1"
}

resource "aws_eks_addon" "CoreDNS" {
  cluster_name    = aws_eks_cluster.cluster.name
  addon_name      = "coredns"
  addon_version   = "v1.11.3-eksbuild.2"
}