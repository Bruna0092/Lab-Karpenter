output "private_subnets" {
  value = {
        "eks-public-us-east-1a" = aws_subnet.eks-public-us-east-1a.id
        "eks-public-us-east-1b" = aws_subnet.eks-public-us-east-1b.id
    }
}

output "security_group_eks" {
  value = {
        "eks_default_sg_nodes" = aws_security_group.eks_default_sg_nodes.id
    }
}