output "private_subnets" {
  value = {
        "eks-public-us-east-1a" = aws_subnet.eks-public-us-east-1a.id
        "eks-public-us-east-1b" = aws_subnet.eks-public-us-east-1b.id
    }
}